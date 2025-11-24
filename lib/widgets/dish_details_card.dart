import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_model.dart';

class DetailsCard extends StatelessWidget {
  final Meal meal;

  const DetailsCard({super.key, required this.meal});

  void _openYoutube(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade300, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(meal.strMealThumb),
            ),
            const SizedBox(height: 16),

            Text(
              meal.strMeal,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('${meal.strCategory ?? ''} • ${meal.strArea ?? ''}'),

            const SizedBox(height: 16),

            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...List.generate(meal.ingredients.length, (i) {
              return Text('${meal.ingredients[i]} - ${meal.measures[i]}');
            }),

            const SizedBox(height: 16),

            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(meal.strInstructions ?? ''),

            const SizedBox(height: 16),

            if (meal.strYoutube != null && meal.strYoutube!.isNotEmpty)
              TextButton(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse(meal.strYoutube!),
                    mode: LaunchMode
                        .externalApplication, // ќе отвори во YouTube апликација или browser
                  );
                },
                child: const Text('Watch on YouTube'),
              ),
          ],
        ),
      ),
    );
  }
}
