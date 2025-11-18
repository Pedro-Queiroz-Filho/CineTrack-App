import 'package:flutter/material.dart';
import '../movie.dart';

import './telas/movie_card.dart'; // seu MovieCard atualizado

class GeralPage extends StatefulWidget {
  const GeralPage({super.key});

  @override
  State<GeralPage> createState() => _GeralPageState();
}

class _GeralPageState extends State<GeralPage> {
  final moviesCall api = moviesCall();

  final ScrollController _scroll = ScrollController();

  final List<Map<String, dynamic>> movies = [];

  String searchName = "";
  String searchYear = "";

  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();

    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        _searchMovies();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// -----------------------------------------------------
  /// BUSCA GERAL — por Nome, Ano, ou Nome + Ano
  /// -----------------------------------------------------
  Future<void> _searchMovies() async {
    if (isLoading) return;

    // Se não digitou nada → limpa e para
    if (searchName.isEmpty && searchYear.isEmpty) {
      setState(() {
        movies.clear();
        hasMore = false;
      });
      return;
    }

    // Se digitou ano mas não tem 4 dígitos, não faz requisição
    if (searchYear.isNotEmpty && searchYear.length != 4) {
      setState(() {
        movies.clear();
        hasMore = false;
      });
      return;
    }

    setState(() => isLoading = true);

    List<dynamic> results = [];
    int totalPages = 1;

    try {
      // Nome + ano: pesquisar por nome e filtrar localmente pelo ano,
      // iterando páginas a partir de currentPage até achar itens ou até totalPages.
      if (searchName.isNotEmpty && searchYear.isNotEmpty) {
        int page = currentPage;

        while (true) {
          final data = await api.searchMovies(searchName, page: page);
          final List pageResults = data["results"] ?? [];
          totalPages = data["total_pages"] ?? 1;

          // filtra localmente pelo ano
          final filtered = pageResults.where((m) {
            final release = (m["release_date"] ?? "").toString();
            return release.startsWith(searchYear);
          }).toList();

          if (filtered.isNotEmpty) {
            results = filtered;
            page++; // próxima página para futuras buscas
            break;
          }

          // se já percorremos todas as páginas, quebra
          if (page >= totalPages) {
            page = totalPages + 1;
            break;
          }

          page++;
        }

        // define hasMore e atualiza currentPage para a próxima página ainda não lida
        if (page <= totalPages) {
          hasMore = true;
          currentPage = page;
        } else {
          hasMore = false;
          currentPage = page; // ficará > totalPages
        }
      }
      // Só nome
      else if (searchName.isNotEmpty) {
        final data = await api.searchMovies(searchName, page: currentPage);
        results = data["results"] ?? [];
        totalPages = data["total_pages"] ?? 1;

        hasMore = currentPage < totalPages;
        currentPage++;
      }
      // Só ano
      else {
        // já garantimos que searchYear.length == 4
        final data = await api.searchByYear(searchYear, page: currentPage);
        results = data["results"] ?? [];
        totalPages = data["total_pages"] ?? 1;

        hasMore = currentPage < totalPages;
        currentPage++;
      }
    } catch (e) {
      // erro na requisição — limpa e retorna
      setState(() {
        isLoading = false;
        hasMore = false;
      });
      return;
    }

    if (results.isEmpty) {
      setState(() {
        isLoading = false;
        // se não tem resultados e não tem mais páginas, garante hasMore = false
        if (!hasMore) hasMore = false;
      });
      return;
    }

    // Formatar resultados (agora incluindo o id)
    final formatted = results.map<Map<String, dynamic>>((m) {
      final release = m["release_date"] ?? "";
      final year = (release is String && release.isNotEmpty)
          ? (release.length >= 4 ? release.substring(0, 4) : "")
          : "";

      return {
        "id": m["id"], // <- importante: inclui id
        "title": m["title"] ?? "Sem nome",
        "poster": m["poster_path"],
        "rating": (m["vote_average"] is num) ? (m["vote_average"] as num).toDouble() : 0.0,
        "year": year,
      };
    }).toList();

    setState(() {
      movies.addAll(formatted);
      isLoading = false;
    });
  }

  void _updateFilters() {
    setState(() {
      movies.clear();
      hasMore = true;
      currentPage = 1;
    });

    _searchMovies();
  }

  String _img(String? path) {
    if (path == null) {
      return "https://via.placeholder.com/400x600?text=Sem+Imagem";
    }
    return "https://image.tmdb.org/t/p/w500$path";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0D0D0F),
      appBar: AppBar(
        title: const Text("Buscar Filmes"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // BUSCA POR NOME
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              onChanged: (v) {
                searchName = v.trim();
                _updateFilters();
              },
              style: const TextStyle(color: Colors.white),
              decoration: _input("Buscar por nome", Icons.search),
            ),
          ),

          // BUSCA POR ANO (exige 4 dígitos)
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: TextField(
              maxLength: 4,
              keyboardType: TextInputType.number,
              onChanged: (v) {
                searchYear = v.trim();
                _updateFilters();
              },
              style: const TextStyle(color: Colors.white),
              decoration: _input("Ano (ex: 2020) — digite 4 dígitos", Icons.calendar_today),
            ),
          ),

          const SizedBox(height: 10),

          // LISTA DE RESULTADOS
          Expanded(
            child: GridView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: movies.length + (hasMore ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // DUAS COLUNAS
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.53, // proporcional ao MovieCard
              ),
              itemBuilder: (context, index) {
                if (index == movies.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final m = movies[index];

                return MovieCard(
                  movieId: (m["id"] is int) ? m["id"] as int : int.tryParse("${m["id"]}") ?? 0,
                  imageUrl: _img(m["poster"]),
                  title: m["title"],
                  rating: (m["rating"] is num) ? (m["rating"] as num).toDouble() : 0.0,
                  category: m["year"], // usando ANO como categoria
                  onRate: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Avaliar: ${m["title"]}")),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _input(String hint, IconData icon) {
    return InputDecoration(
      counterText: "",
      filled: true,
      fillColor: Colors.white10,
      prefixIcon: Icon(icon, color: Colors.white54),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
