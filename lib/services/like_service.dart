import 'package:hive_flutter/hive_flutter.dart';

class LikeService {
  static final Box _box = Hive.box('liked_movies');

  /// Salvar ou remover um filme curtido
  static void toggleLike({
    required int id,
    required String title,
    required String poster,
  }) {
    if (_box.containsKey(id)) {
      _box.delete(id);
    } else {
      _box.put(id, {
        "id": id,
        "title": title,
        "poster": poster,
      });
    }
  }

  /// Verifica se já está curtid
  static bool isLiked(int id) {
    return _box.containsKey(id);
  }
}
