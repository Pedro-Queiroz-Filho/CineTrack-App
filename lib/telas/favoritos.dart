import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/review_service.dart';
import '../../services/rating_service.dart';
import '../telas/movie_card.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final Box box = Hive.box('liked_movies');

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xff0D0D0F);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          "Favoritos",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, _, __) {
          final favoritos = box.values.toList();

          if (favoritos.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum filme favoritado 💔",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favoritos.length,
            itemBuilder: (context, i) {
              final fav = favoritos[i];
              final movieId = fav["id"];

              final review = ReviewService.getReview(movieId);
              final rating = RatingService.getRating(movieId);

              final ratingController =
              TextEditingController(text: rating.toString());

              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [

                      /// --- MOVIECARD JÁ RECEBE A NOTA ATUALIZADA ---
                      MovieCard(
                        movieId: movieId,
                        imageUrl: fav["poster"],
                        title: fav["title"],
                        rating: rating,           // 🔥 agora usa a nota do usuário
                        category: "Favorito",
                        onRate: () {},
                      ),

                      const SizedBox(height: 10),

                      /// --- CAMPO PARA NOTA ---
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: ratingController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Sua nota (0 a 10)",
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black26,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        onChanged: (value) {
                          final double? newRating = double.tryParse(value);

                          if (newRating != null &&
                              newRating >= 0 &&
                              newRating <= 10) {

                            RatingService.saveRating(movieId, newRating);

                            /// 🔥 Atualiza instantaneamente a UI
                            setState(() {});
                          }
                        },
                      ),

                      const SizedBox(height: 10),

                      /// --- CAMPO PARA REVIEW ---
                      TextField(
                        controller: TextEditingController(text: review),
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Sua avaliação pessoal",
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black26,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (text) {
                          ReviewService.saveReview(movieId, text);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
