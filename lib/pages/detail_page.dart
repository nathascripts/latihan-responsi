import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatelessWidget {
  final String idMeal;
  const DetailPage({super.key, required this.idMeal});

  Future<void> _addToFavorites(Map<String, dynamic> meal) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favoriteMeals') ?? [];

    if (!favorites.contains(meal['id'])) {
      favorites.add(meal['id']);
      await prefs.setStringList('favoriteMeals', favorites);
      debugPrint("Saved!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Detail')),
      body: FutureBuilder(
        future: ApiService.fetchMealDetail(idMeal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final meal = snapshot.data as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(meal['strMealThumb']),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(meal['strMeal'],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(meal['strInstructions'] ?? ''),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _addToFavorites({
                            'id': meal['idMeal'],
                            'name': meal['strMeal'],
                            'thumbnail': meal['strMealThumb']
                          }),
                          child: const Text('Add to Favorites'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
