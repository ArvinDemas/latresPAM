import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/amiibo_model.dart';

class FavoriteService {
  static const String _key = 'favorites';

  // Get all favorites
  static Future<List<Amiibo>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_key);

    if (favoritesJson == null) return [];

    final List<dynamic> decoded = json.decode(favoritesJson);
    return decoded.map((json) => Amiibo.fromJson(json)).toList();
  }

  // Add to favorites
  static Future<void> addFavorite(Amiibo amiibo) async {
    final prefs = await SharedPreferences.getInstance();
    List<Amiibo> favorites = await getFavorites();

    // Check if already exists to prevent duplicates
    if (!favorites.any((item) => item.head == amiibo.head && item.tail == amiibo.tail)) {
      favorites.add(amiibo);
      final String encoded = json.encode(favorites.map((e) => e.toJson()).toList());
      await prefs.setString(_key, encoded);
    }
  }

  // Remove from favorites
  static Future<void> removeFavorite(Amiibo amiibo) async {
    final prefs = await SharedPreferences.getInstance();
    List<Amiibo> favorites = await getFavorites();

    favorites.removeWhere((item) => item.head == amiibo.head && item.tail == amiibo.tail);

    final String encoded = json.encode(favorites.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  // Check if is favorite
  static Future<bool> isFavorite(Amiibo amiibo) async {
    List<Amiibo> favorites = await getFavorites();
    return favorites.any((item) => item.head == amiibo.head && item.tail == amiibo.tail);
  }
}