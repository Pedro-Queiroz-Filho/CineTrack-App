import 'package:flutter/material.dart';
import '../movie.dart';
import 'geral.dart';
import '../telas/movie_card.dart';
import 'telas/assistidos.dart';
import 'telas/destaques.dart';
import '../services/like_service.dart';
import 'telas/favoritos.dart';
import 'telas/pendentes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final moviesCall api = moviesCall();

  late Future<Map<String, dynamic>> popularFuture;
  late Future<List<dynamic>> actionFuture;
  late Future<List<dynamic>> dramaFuture;
  late Future<List<dynamic>> comedyFuture;
  late Future<List<dynamic>> horrorFuture;

  @override
  void initState() {
    super.initState();
    popularFuture = api.fetchPopularMoviesJson();
    actionFuture = api.fetchMoviesByGenre(28);
    dramaFuture = api.fetchMoviesByGenre(18);
    comedyFuture = api.fetchMoviesByGenre(35);
    horrorFuture = api.fetchMoviesByGenre(27);
  }

  String _img(String? p) =>
      (p == null || p.isEmpty)
          ? "https://via.placeholder.com/500x750?text=Sem+Imagem"
          : "https://image.tmdb.org/t/p/w500$p";

  Widget buildCategory(String title, Future<List<dynamic>> future) {
    final Color imdbYellow = const Color(0xFFF5C518);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: imdbYellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GeralPage()),
                  );
                },
                child: const Text("Ver tudo", style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 300,
          child: FutureBuilder<List<dynamic>>(
            future: future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              if (snap.hasError) {
                return const Center(
                  child: Text("Erro ao carregar categoria",
                      style: TextStyle(color: Colors.red)),
                );
              }

              final list = snap.data ?? [];
              if (list.isEmpty) {
                return const Center(
                  child: Text("Nenhum filme nesta categoria",
                      style: TextStyle(color: Colors.white70)),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final movie = list[i];

                  final int movieId = movie['id'] ?? 0;
                  final poster = movie['poster_path'];
                  final title = movie['title'] ?? 'Sem título';
                  final double rating = (movie['vote_average'] ?? 0).toDouble();

                  return MovieCard(
                    movieId: movieId,
                    imageUrl: _img(poster),
                    title: title,
                    rating: rating,
                    category: title,
                    onRate: () {},
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xff0D0D0F);
    final Color imdbYellow = const Color(0xFFF5C518);

    return Scaffold(
      backgroundColor: bg,

      /// ==========================
      ///     BOTÃO DE FAVORITOS
      /// ==========================
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "CineTrack",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          /// ===== BOTÃO DE PENDENTES =====
          IconButton(
            tooltip: "Filmes Pendentes",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PendentesPage()),
              );
            },
            icon: const Icon(Icons.schedule, color: Colors.yellowAccent, size: 27),
          ),

          /// ===== BOTÃO DE ASSISTIDOS =====
          IconButton(
            tooltip: "Filmes Assistidos",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WatchedPage()),
              );
            },
            icon: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 27),
          ),

          /// ===== FAVORITOS =====
          IconButton(
            tooltip: "Favoritos",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritosPage()),
              );
            },
            icon: const Icon(Icons.favorite, color: Colors.redAccent, size: 28),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: popularFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Erro ao carregar filmes", style: TextStyle(color: Colors.red)),
              );
            }

            final List results = snapshot.data?['results'] ?? [];

            return ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.33,
                  child: const DestaqueFilmes(),
                ),
                const SizedBox(height: 15),

                /// POPULARES
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Populares",
                          style: TextStyle(
                              color: imdbYellow,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const GeralPage()),
                        ),
                        child: const Text("Ver tudo", style: TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: results.length,
                    itemBuilder: (context, i) {
                      final movie = results[i];

                      final int movieId = movie['id'] ?? 0;
                      final poster = movie['poster_path'];
                      final title = movie['title'] ?? 'Sem título';
                      final double rating = (movie['vote_average'] ?? 0).toDouble();

                      return MovieCard(
                        movieId: movieId,
                        imageUrl: _img(poster),
                        title: title,
                        rating: rating,
                        category: "Filme",
                        onRate: () {},
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// CATEGORIAS
                buildCategory("Ação", actionFuture),
                buildCategory("Drama", dramaFuture),
                buildCategory("Comédia", comedyFuture),
                buildCategory("Terror", horrorFuture),
              ],
            );
          },
        ),
      ),
    );
  }
}
