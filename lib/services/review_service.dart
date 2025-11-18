import 'package:hive_flutter/hive_flutter.dart';

class ReviewService {
  static final Box _box = Hive.box("movie_reviews");

  /// Salva ou altera a avaliação de um filme
  static Future<void> saveReview(int movieId, String review) async {
    await _box.put(movieId, review);
  }

  /// Retorna a avaliação armazenada (ou "" caso não exista)
  static String getReview(int movieId) {
    return _box.get(movieId, defaultValue: "") ?? "";
  }

  /// Remove a avaliação
  static Future<void> removeReview(int movieId) async {
    await _box.delete(movieId);
  }
}
