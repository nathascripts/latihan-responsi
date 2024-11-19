import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Fetch meal list
  static Future<List<dynamic>> fetchMeals() async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=Seafood'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // Fetch meal detail
  static Future<Map<String, dynamic>> fetchMealDetail(String idMeal) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$idMeal'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['meals'][0];
    } else {
      throw Exception('Failed to load meal detail');
    }
  }
}
