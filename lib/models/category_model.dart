class FoodCategory {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  FoodCategory({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> data) {
    return FoodCategory(
      idCategory: data['idCategory'] ?? '',
      strCategory: data['strCategory'] ?? '',
      strCategoryThumb: data['strCategoryThumb'] ?? '',
      strCategoryDescription: data['strCategoryDescription'] ?? '',
    );
  }
}
