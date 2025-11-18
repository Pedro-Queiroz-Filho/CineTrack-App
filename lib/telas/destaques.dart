import 'dart:async';
import 'package:flutter/material.dart';
import '../../movie.dart';

const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

class DestaqueFilmes extends StatefulWidget {
  const DestaqueFilmes({super.key});

  @override
  State<DestaqueFilmes> createState() => _DestaqueFilmesState();
}

class _DestaqueFilmesState extends State<DestaqueFilmes> {
  late Future<Map<String, dynamic>> _futureMovies;
  final moviesCall _api = moviesCall();

  final PageController _controller = PageController(viewportFraction: 1.0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _futureMovies = _api.fetchPopularMoviesJson();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> _mapMovies(Map<String, dynamic> data) {
    final List results = data["results"] ?? [];

    return results.map((movie) {
      final poster = movie["poster_path"] ?? "";
      final title = movie["title"] ?? "Sem título";

      return {
        "imageUrl": poster.isNotEmpty
            ? "$_imageBaseUrl$poster"
            : "https://via.placeholder.com/500x750?text=Sem+Imagem",
        "title": title,
      };
    }).toList();
  }

  void _startTimer(int length) {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_controller.hasClients) return;

      _currentPage = (_currentPage + 1) % length;

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.38;

    return FutureBuilder(
      future: _futureMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: height,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: height,
            child: const Center(
              child: Text(
                "Erro ao carregar destaques",
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return SizedBox(height: height);
        }

        final filmes = _mapMovies(snapshot.data!);

        if (_timer == null && filmes.length > 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startTimer(filmes.length);
          });
        }

        return SizedBox(
          height: height,
          child: PageView.builder(
            controller: _controller,
            itemCount: filmes.length,
            itemBuilder: (context, index) {
              final filme = filmes[index];

              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    // IMAGEM — sem corte
                    Positioned.fill(
                      child: Image.network(
                        filme["imageUrl"]!,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // GRADIENTE LEVE EM BAIXO
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.55),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // TÍTULO NO CANTO INFERIOR ESQUERDO — sem overflow
                    Positioned(
                      left: 16,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.60),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth:
                            MediaQuery.of(context).size.width * 0.80,
                          ),
                          child: Text(
                            filme["title"]!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16, // menor como pediu
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
