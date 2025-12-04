import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/local_notification_service.dart';
import '../services/meal_api_service.dart';
import '../widgets/meal_card.dart';
import 'favorites_screen.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;

  const MealsScreen({super.key, required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealApiService _apiService = MealApiService();
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  List<String> _favoriteIds = [];

  final _localNotificationService = LocalNotificationService();

  @override
  void initState() {
    super.initState();
    _loadMeals();
    _localNotificationService.scheduleDailyRecipeNotification();
  }



  void _loadMeals() async {
    final mealsList = await _apiService.loadMealsByCategory(widget.category);
    setState(() {
      _meals = mealsList;
      _filteredMeals = mealsList;
      _isLoading = false;
    });
  }

  void _filterMeals(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredMeals = _meals;
      });
    } else {
      final searchedMeals = await _apiService.searchMeals(query);
      setState(() {
        _filteredMeals = searchedMeals
            .where((meal) => meal.strCategory == widget.category)
            .toList();
      });
    }
  }

  void _toggleFavorite(Meal meal) {
    setState(() {
      if (_favoriteIds.contains(meal.idMeal)) {
        _favoriteIds.remove(meal.idMeal);
      } else {
        _favoriteIds.add(meal.idMeal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Meals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () {
              final favMeals = _meals.where((m) => _favoriteIds.contains(m.idMeal)).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favorites: favMeals,
                    favoriteIds: _favoriteIds,
                    onToggleFavorite: _toggleFavorite,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Random Meal',
            onPressed: () async {
              final randomMeal = await _apiService.getRandomMeal();
              if (randomMeal != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealDetailScreen(idMeal: randomMeal.idMeal),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search meals...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _filterMeals(value);
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 200 / 244,
              ),
              itemCount: _filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = _filteredMeals[index];
                final isFav = _favoriteIds.contains(meal.idMeal);
                return MealCard(
                  meal: meal,
                  isFavorite: isFav,
                  onToggleFavorite: () => _toggleFavorite(meal),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
