import 'package:flutter/material.dart';

class SuaImagem extends StatelessWidget {
  final String caminhoArquivo;
  final double? largura;
  final double? altura;
  final double bordaArredondada;
  final BoxFit ajuste;
  final Color? corFundo;
  final BoxBorder? borda;
  final List<BoxShadow>? sombras;

  const SuaImagem({
    Key? key,
    required this.caminhoArquivo,
    this.largura,
    this.altura,
    this.bordaArredondada = 0,
    this.ajuste = BoxFit.cover,
    this.corFundo,
    this.borda,
    this.sombras,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      height: altura,
      decoration: BoxDecoration(
        color: corFundo ?? Colors.transparent,
        borderRadius: BorderRadius.circular(bordaArredondada),
        border: borda,
        boxShadow: sombras,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        caminhoArquivo,
        fit: ajuste,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
          );
        },
      ),
    );
  }
}
