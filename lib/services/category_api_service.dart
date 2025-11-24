import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class FoodCategoryApiService {
  Future<List<FoodCategory>> loadCategories() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<dynamic> categoriesJson = data['categories'];
      return categoriesJson.map((json) => FoodCategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
