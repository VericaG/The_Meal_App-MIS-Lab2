class Meal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strYoutube;
  final List<String> ingredients;
  final List<String> measures;

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strYoutube,
    this.ingredients = const [],
    this.measures = const [],
  });

  factory Meal.fromJson(Map<String, dynamic> data) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = data['strIngredient$i'];
      final measure = data['strMeasure$i'];
      if (ingredient != null && ingredient.toString().isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }

    return Meal(
      idMeal: data['idMeal'] ?? '',
      strMeal: data['strMeal'] ?? '',
      strMealThumb: data['strMealThumb'] ?? '',
      strCategory: data['strCategory'],
      strArea: data['strArea'],
      strInstructions: data['strInstructions'],
      strYoutube: data['strYoutube'],
      ingredients: ingredients,
      measures: measures,
    );
  }
}
