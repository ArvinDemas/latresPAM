import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/amiibo_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.amiiboapi.com/api';

  // Get all amiibo [cite: 7]
  static Future<List<Amiibo>> getAllAmiibo() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/amiibo'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> amiiboList = data['amiibo'];
        return amiiboList.map((json) => Amiibo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load amiibo');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get amiibo by head [cite: 8]
  static Future<List<Amiibo>> getAmiiboByHead(String head) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/amiibo/?head=$head'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> amiiboList = data['amiibo'];
        return amiiboList.map((json) => Amiibo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load amiibo detail');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}