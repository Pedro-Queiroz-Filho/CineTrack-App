import 'package:flutter/material.dart';
import '../widgets/texto.dart';
import '../services/like_service.dart';
import '../services/pending_service.dart'; // ⬅ IMPORTANTE
import '../telas/detalhes_page.dart';

class MovieCard extends StatefulWidget {
  final int movieId;
  final String imageUrl;
  final String title;
  final double rating;
  final String category;
  final VoidCallback onRate;

  MovieCard({
    super.key,
    required this.movieId,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.category,
    required this.onRate,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool isLiked = false;
  bool isPending = false;

  @override
  void initState() {
    super.initState();
    isLiked = LikeService.isLiked(widget.movieId);
    isPending = PendingService.isPending(widget.movieId);
  }

  void toggleLike() {
    LikeService.toggleLike(
      id: widget.movieId,
      title: widget.title,
      poster: widget.imageUrl,
    );

    setState(() {
      isLiked = !isLiked;
    });
  }

  void togglePending() {
    PendingService.togglePending(
      id: widget.movieId,
      title: widget.title,
      poster: widget.imageUrl,
    );

    setState(() {
      isPending = !isPending;
    });
  }

  void openDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalhesPage(movieId: widget.movieId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openDetails,
      child: SizedBox(
        width: 180,
        height: 330,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  widget.imageUrl,
                  height: 185,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 185,
                    child: Center(
                      child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Textos(
                        widget.title,
                        Colors.white,
                        tamanhoFonte: 15,
                        pesoFonte: FontWeight.bold,
                        maxLinhas: 1,
                        overflow: TextOverflow.ellipsis,
                        padding: EdgeInsets.zero,
                      ),

                      const SizedBox(height: 4),

                      Textos(
                        widget.category,
                        Colors.white70,
                        tamanhoFonte: 12,
                        pesoFonte: FontWeight.w400,
                        maxLinhas: 1,
                        overflow: TextOverflow.ellipsis,
                        padding: EdgeInsets.zero,
                      ),

                      const Spacer(),

                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 3),

                          Textos(
                            widget.rating.toStringAsFixed(1),
                            Colors.white,
                            tamanhoFonte: 14,
                            pesoFonte: FontWeight.bold,
                            padding: EdgeInsets.zero,
                          ),

                          const Spacer(),

                          Column(
                            children: [
                              // ❤️ Botão de curtir
                              SizedBox(
                                height: 26,
                                width: 26,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: toggleLike,
                                  icon: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                ),
                              ),

                              // ⏳ Botão de Pendentes (NOVO)
                              SizedBox(
                                height: 26,
                                width: 26,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: togglePending,
                                  icon: Icon(
                                    isPending ? Icons.check_circle : Icons.schedule,
                                    color: isPending ? Colors.greenAccent : Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
