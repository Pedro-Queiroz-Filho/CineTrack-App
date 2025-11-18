import 'package:flutter/material.dart';
import '../../services/pending_service.dart';
import '../../services/watched_service.dart';

class PendentesPage extends StatefulWidget {
  const PendentesPage({super.key});

  @override
  State<PendentesPage> createState() => _PendentesPageState();
}

class _PendentesPageState extends State<PendentesPage> {
  List<Map> pendentes = [];

  @override
  void initState() {
    super.initState();
    carregarPendentes();
  }

  void carregarPendentes() {
    setState(() {
      pendentes = PendingService.getAllPending();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color imdbYellow = const Color(0xFFF5C518);

    return Scaffold(
      backgroundColor: const Color(0xff0F0F11),

      appBar: AppBar(
        backgroundColor: const Color(0xff1A1A1D),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 26, color: imdbYellow),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "📌 Pendentes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: imdbYellow,
          ),
        ),
      ),

      body: pendentes.isEmpty
          ? const Center(
        child: Text(
          "Nenhum filme pendente",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: pendentes.length,
        itemBuilder: (context, index) {
          final filme = pendentes[index];

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
                      left: Radius.circular(12)),
                  child: Image.network(
                    filme["poster"],
                    width: 110,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                /// Título + botão
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

                      /// Botão "Marcar como visto"
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: imdbYellow,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          /// 1️⃣ Remove dos pendentes
                          PendingService.removePending(filme["id"]);

                          /// 2️⃣ Adiciona aos assistidos
                          WatchedService.addWatched(
                            id: filme["id"],
                            title: filme["title"],
                            poster: filme["poster"],
                          );

                          /// 3️⃣ Atualiza tela
                          carregarPendentes();
                        },
                        icon: const Icon(Icons.check),
                        label: const Text("Marcar como visto"),
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
