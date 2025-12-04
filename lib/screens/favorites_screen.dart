import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../widgets/meal_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Meal> favorites;
  final List<String> favoriteIds;
  final Function(Meal) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.favoriteIds,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites")),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 200 / 244,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final meal = favorites[index];
          return MealCard(
            meal: meal,
            isFavorite: favoriteIds.contains(meal.idMeal),
            onToggleFavorite: () => onToggleFavorite(meal),
          );
        },
      ),
    );
  }
}
