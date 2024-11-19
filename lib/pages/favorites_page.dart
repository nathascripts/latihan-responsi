import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favoriteMeals = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteMeals = prefs.getStringList('favoriteMeals') ?? [];
    });
  }

  Future<void> _removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    favoriteMeals.remove(mealId);
    await prefs.setStringList('favoriteMeals', favoriteMeals);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favoriteMeals.isEmpty
          ? const Center(child: Text('No favorites added yet.'))
          : ListView.builder(
              itemCount: favoriteMeals.length,
              itemBuilder: (context, index) {
                final mealId = favoriteMeals[index];
                return ListTile(
                  title: Text(
                      mealId), // Ganti dengan nama asli jika di-fetch ulang
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFavorite(mealId),
                  ),
                );
              },
            ),
    );
  }
}
