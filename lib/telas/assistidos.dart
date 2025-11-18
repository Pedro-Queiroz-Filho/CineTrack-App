import 'package:flutter/material.dart';
import '../../services/watched_service.dart';

class WatchedPage extends StatefulWidget {
  const WatchedPage({super.key});

  @override
  State<WatchedPage> createState() => _WatchedPageState();
}

class _WatchedPageState extends State<WatchedPage> {
  List<Map> assistidos = [];

  @override
  void initState() {
    super.initState();
    carregarAssistidos();
  }

  void carregarAssistidos() {
    setState(() {
      assistidos = WatchedService.getAllWatched();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0F11),

      appBar: AppBar(
        backgroundColor: const Color(0xff1A1A1D),
        centerTitle: true,

        /// 🔥 Botão de voltar mais visível
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 26,
            shadows: [
              Shadow(color: Colors.black, blurRadius: 8),
            ],
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "🎞 Filmes Assistidos",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),

      body: assistidos.isEmpty
          ? const Center(
        child: Text(
          "Nenhum filme assistido ainda",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: assistidos.length,
        itemBuilder: (context, index) {
          final filme = assistidos[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                /// Poster
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                  child: Image.network(
                    filme["poster"],
                    width: 110,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                /// Título + botão remover
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        filme["title"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          WatchedService.removeWatched(filme["id"]);
                          carregarAssistidos();
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Remover"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
