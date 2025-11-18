import 'package:hive_flutter/hive_flutter.dart';

class WatchedService {
  static final Box _box = Hive.box('watched_movies');

  /// Adiciona um filme à lista de assistidos
  static void addWatched({
    required int id,
    required String title,
    required String poster,
  }) {
    _box.put(id, {
      "id": id,
      "title": title,
      "poster": poster,
    });
  }

  /// Remove um filme da lista de assistidos
  static void removeWatched(int id) {
    if (_box.containsKey(id)) {
      _box.delete(id);
    }
  }

  /// Verifica se um filme já está na lista de assistidos
  static bool isWatched(int id) {
    return _box.containsKey(id);
  }

  /// Retorna todos os filmes assistidos
  static List<Map> getAllWatched() {
    return _box.values.map((e) => Map.from(e)).toList();
  }
}
