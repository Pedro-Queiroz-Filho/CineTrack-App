import 'package:hive_flutter/hive_flutter.dart';

class RatingService {
  static final Box _box = Hive.box("movie_ratings");

  /// Salvar nota de 0 a 10
  static Future<void> saveRating(int movieId, double rating) async {
    await _box.put(movieId, rating);
  }

  /// Buscar a nota salva
  static double getRating(int movieId) {
    return (_box.get(movieId, defaultValue: 0.0) as double);
  }
}
