import 'package:flutter/material.dart';
import '../widgets/texto.dart';
import '../movie.dart';

class DetalhesPage extends StatefulWidget {
  final int movieId;

  const DetalhesPage({super.key, required this.movieId});

  @override
  State<DetalhesPage> createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  Map<String, dynamic>? movie;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarDetalhes();
  }

  Future<void> carregarDetalhes() async {
    final api = moviesCall();
    final result = await api.fetchMovieDetails(widget.movieId);

    setState(() {
      movie = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : movie == null
          ? const Center(
          child: Text("Erro ao carregar dados.", style: TextStyle(color: Colors.white)))
          : CustomScrollView(
        slivers: [
          // ------------------------ CAPA ------------------------
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie!["title"] ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black, blurRadius: 12)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "https://image.tmdb.org/t/p/original${movie!["backdrop_path"]}",
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black.withOpacity(0.4)),
                ],
              ),
            ),
          ),

          // ------------------------ CORPO ------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------------ POSTER + INFO ------------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500${movie!["poster_path"]}",
                          width: 130,
                          errorBuilder: (_, __, ___) => Container(
                            width: 130,
                            height: 190,
                            color: Colors.grey.shade700,
                            child: const Icon(Icons.broken_image, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // -------- TITULO + NOTA + GÊNEROS --------
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Textos(
                              movie!["title"] ?? "",
                              Colors.white,
                              tamanhoFonte: 20,
                              pesoFonte: FontWeight.bold,
                            ),
                            const SizedBox(height: 6),

                            // NOTA
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 20),
                                const SizedBox(width: 6),
                                Textos(
                                  (movie!["vote_average"] ?? 0)
                                      .toDouble()
                                      .toStringAsFixed(1),
                                  Colors.white,
                                  tamanhoFonte: 17,
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // -------- GÊNEROS (melhor alinhados) --------
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 6,
                              runSpacing: 6,
                              children: (movie!["genres"] as List<dynamic>).map((g) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade500,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    g["name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // ------------------------ SINOPSE ------------------------
                  Textos("Sinopse", Colors.white,
                      tamanhoFonte: 18, pesoFonte: FontWeight.bold),
                  const SizedBox(height: 6),
                  Textos(
                    movie!["overview"] ?? "Sem sinopse disponível.",
                    Colors.white70,
                    tamanhoFonte: 15,
                  ),

                  const SizedBox(height: 25),

                  // ------------------------ INFORMAÇÕES ------------------------
                  Textos("Informações", Colors.white,
                      tamanhoFonte: 18, pesoFonte: FontWeight.bold),
                  const SizedBox(height: 12),

                  infoItem("Lançamento:", movie!["release_date"] ?? "—"),
                  infoItem("Duração:", "${movie!["runtime"] ?? 0} min"),
                  infoItem("Status:", movie!["status"] ?? "—"),

                  const SizedBox(height: 25),

                  // ------------------------ PRODUTORAS ------------------------
                  Textos("Produtoras", Colors.white,
                      tamanhoFonte: 18, pesoFonte: FontWeight.bold),
                  const SizedBox(height: 10),

                  ..._buildProdutoras(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------ ITEM DE INFORMAÇÃO ------------------------
  Widget infoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Textos(title, Colors.white,
              tamanhoFonte: 15, pesoFonte: FontWeight.bold),
          const SizedBox(width: 8),
          Expanded(
            child: Textos(
              value,
              Colors.white70,
              tamanhoFonte: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------ PRODUTORAS (LIMITADAS E AJUSTADAS) ------------------------
  List<Widget> _buildProdutoras() {
    final list = movie!["production_companies"] as List<dynamic>;
    final limitadas = list.take(5).toList();

    return limitadas.map<Widget>((c) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          "• ${c["name"]}",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      );
    }).toList();
  }
}
