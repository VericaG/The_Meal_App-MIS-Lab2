import 'package:the_meal_app/models/category_model.dart';
import 'package:flutter/material.dart';

import 'categoryCard.dart';

class CategoriesGrid extends StatefulWidget {
  final List<FoodCategory> categories;

  const CategoriesGrid({super.key, required this.categories});

  @override
  State<StatefulWidget> createState() => _CategoriesGrid();
}

class _CategoriesGrid extends State<CategoriesGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 200 / 344,
      ),
      itemCount: widget.categories.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return CategoryCard(category: widget.categories[index]);
      },
    );
  }
}
