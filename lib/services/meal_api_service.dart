import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';

class MealApiService {
  Future<List<Meal>> loadMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category',
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> mealsJson = data['meals'];
      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic>? mealsJson = data['meals'];
      if (mealsJson == null) return [];
      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }

  Future<Meal?> getMealDetails(String idMeal) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic>? mealsJson = data['meals'];
      if (mealsJson == null || mealsJson.isEmpty) return null;
      return Meal.fromJson(mealsJson[0]);
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  Future<Meal?> getRandomMeal() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic>? mealsJson = data['meals'];
      if (mealsJson == null || mealsJson.isEmpty) return null;
      return Meal.fromJson(mealsJson[0]);
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}
