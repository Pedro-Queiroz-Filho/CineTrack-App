import 'package:hive_flutter/hive_flutter.dart';

class PendingService {
  static final Box _box = Hive.box('pending_movies');

  /// Adiciona ou remove o filme na lista de pendentes
  static void togglePending({
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

  /// Verifica se o filme já está marcado como pendente
  static bool isPending(int id) {
    return _box.containsKey(id);
  }

  /// Retorna todos os filmes pendentes em forma de lista
  static List<Map> getAllPending() {
    return _box.values.map((e) => Map.from(e)).toList();
  }

  /// Remove completamente um filme da lista de pendentes
  static void removePending(int id) {
    if (_box.containsKey(id)) {
      _box.delete(id);
    }
  }
}
