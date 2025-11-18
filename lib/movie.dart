import 'dart:convert';
import 'package:http/http.dart' as http;

class moviesCall {
  final String apiKey = "bd8c1a5090c34770367095675824cd98";
  final String baseUrl = "https://api.themoviedb.org/3";

  /// Helper para requisições que devolve Map
  Future<Map<String, dynamic>> _get(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      return {
        "results": [],
        "error": "Erro na requisição",
        "status": response.statusCode,
      };
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// ===============================
  /// 1) Filmes Populares
  /// ===============================
  Future<Map<String, dynamic>> fetchPopularMoviesJson({int page = 1}) async {
    return _get(
      "$baseUrl/movie/popular?api_key=$apiKey&language=pt-BR&page=$page",
    );
  }

  /// ===============================
  /// 2) Buscar por nome
  /// ===============================
  Future<Map<String, dynamic>> searchMovies(String query, {int page = 1}) async {
    final q = Uri.encodeQueryComponent(query);
    return _get(
      "$baseUrl/search/movie?api_key=$apiKey&language=pt-BR&query=$q&page=$page&include_adult=false",
    );
  }

  /// ===============================
  /// 3) Buscar por ano
  /// ===============================
  Future<Map<String, dynamic>> searchByYear(String year, {int page = 1}) async {
    return _get(
      "$baseUrl/discover/movie?api_key=$apiKey&language=pt-BR&primary_release_year=$year&page=$page&include_adult=false",
    );
  }

  /// ===============================
  /// 4) Buscar por nome + ano
  /// ===============================
  Future<Map<String, dynamic>> searchByNameAndYear(String name, String year, {int page = 1}) async {
    final q = Uri.encodeQueryComponent(name);
    return _get(
      "$baseUrl/search/movie?api_key=$apiKey&language=pt-BR&query=$q&year=$year&page=$page&include_adult=false",
    );
  }

  /// ===============================
  /// 5) Pegar lista de gêneros
  /// ===============================
  Future<List<Map<String, dynamic>>> fetchGenres() async {
    final data = await _get(
      "$baseUrl/genre/movie/list?api_key=$apiKey&language=pt-BR",
    );

    return (data["genres"] ?? []).map<Map<String, dynamic>>((g) {
      return {
        "id": g["id"],
        "name": g["name"],
      };
    }).toList();
  }

  /// ===============================
  /// 6) Buscar filmes por gênero
  /// ===============================
  Future<List<dynamic>> fetchMoviesByGenre(int genreId, {int page = 1}) async {
    final data = await _get(
      "$baseUrl/discover/movie?api_key=$apiKey&language=pt-BR&with_genres=$genreId&page=$page&include_adult=false&sort_by=popularity.desc",
    );

    return data["results"] ?? [];
  }

  /// ============================================================
  /// ⭐ NOVO: Buscar detalhes completos do filme (SEM QUEBRAR NADA)
  /// ============================================================
  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    return _get(
      "$baseUrl/movie/$movieId?api_key=$apiKey&language=pt-BR&append_to_response=videos,images,credits",
    );
  }
}
