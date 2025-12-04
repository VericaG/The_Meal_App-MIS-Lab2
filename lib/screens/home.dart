import 'package:flutter/material.dart';
import 'package:the_meal_app/models/category_model.dart';
import 'package:the_meal_app/services/category_api_service.dart';
import 'package:the_meal_app/widgets/categories_grid.dart';

import '../services/local_notification_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<FoodCategory> _categories;
  List<FoodCategory> _filteredCategories = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';
  final FoodCategoryApiService _apiService = FoodCategoryApiService();
  final TextEditingController _searchController = TextEditingController();
  final _localNotificationService = LocalNotificationService();

  @override
  void initState() {
    super.initState();
    _loadCategories();

    _localNotificationService.showTestNotification();
    _localNotificationService.scheduleDailyRecipeNotification();
  }

  void _loadCategories() async {
    final categoriesList = await _apiService.loadCategories();
    setState(() {
      _categories = categoriesList;
      _filteredCategories = categoriesList;
      _isLoading = false;
    });
  }

  void _filterCategories(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories
            .where(
              (category) => category.strCategory.toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  Future<void> _searchFoodCategoryByName(String strCategory) async {
    if (strCategory.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    FoodCategory? match;
    try {
      match = _categories.firstWhere(
        (cat) => cat.strCategory.toLowerCase() == strCategory.toLowerCase(),
      );
    } catch (e) {
      match = null;
    }

    setState(() {
      _isSearching = false;
      _filteredCategories = match != null ? [match] : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                      hintText: "Search category by name...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      _filterCategories(value);
                    },
                  ),
                ),
                Expanded(
                  child: _filteredCategories.isEmpty && _searchQuery.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No category found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _isSearching
                                    ? null
                                    : () async {
                                        await _searchFoodCategoryByName(
                                          _searchQuery,
                                        );
                                      },
                                child: _isSearching
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Search in local list'),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: CategoriesGrid(
                            categories: _filteredCategories,
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
