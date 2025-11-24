import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/meal_api_service.dart';
import '../widgets/dish_details_card.dart';

class MealDetailScreen extends StatefulWidget {
  final String idMeal;

  const MealDetailScreen({super.key, required this.idMeal});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApiService _apiService = MealApiService();
  Meal? _meal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMealDetails();
  }

  void _loadMealDetails() async {
    final meal = await _apiService.getMealDetails(widget.idMeal);
    setState(() {
      _meal = meal;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_meal?.strMeal ?? 'Meal Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _meal == null
          ? const Center(child: Text('Meal not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: DetailsCard(meal: _meal!),
            ),
    );
  }
}
