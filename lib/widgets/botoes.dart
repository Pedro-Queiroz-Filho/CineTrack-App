import 'package:flutter/material.dart';

class Botoes extends StatelessWidget {
  final String texto;
  final void Function() onPressed;

  // 🧠 Novas propriedades de personalização
  final Color? corTexto;
  final Color? corFundo;
  final Color? corBorda;
  final double raioBorda;
  final double tamanhoFonte;
  final double? largura;
  final double? altura;
  final FontWeight pesoFonte;
  final IconData? iconeEsquerda;
  final IconData? iconeDireita;
  final List<BoxShadow>? sombras;
  final EdgeInsetsGeometry? padding;

  const Botoes(
      this.texto, {
        super.key,
        required this.onPressed,
        this.corTexto,
        this.corFundo,
        this.corBorda,
        this.raioBorda = 12.0,
        this.tamanhoFonte = 16.0,
        this.largura,
        this.altura,
        this.pesoFonte = FontWeight.w600,
        this.iconeEsquerda,
        this.iconeDireita,
        this.sombras,
        this.padding,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura ?? double.infinity,
      height: altura,
      decoration: BoxDecoration(
        boxShadow: sombras ??
            [
              BoxShadow(
                color: (corFundo ?? Colors.blueAccent).withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: corFundo ?? Colors.blueAccent,
          foregroundColor: corTexto ?? Colors.white,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(raioBorda),
            side: BorderSide(color: corBorda ?? Colors.transparent),
          ),
          elevation: 0, // sombra controlada no container externo
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconeEsquerda != null)
              Icon(iconeEsquerda, size: 22, color: corTexto ?? Colors.white),
            if (iconeEsquerda != null) const SizedBox(width: 8),
            Text(
              texto,
              style: TextStyle(
                fontSize: tamanhoFonte,
                fontWeight: pesoFonte,
                color: corTexto ?? Colors.white,
              ),
            ),
            if (iconeDireita != null) const SizedBox(width: 8),
            if (iconeDireita != null)
              Icon(iconeDireita, size: 22, color: corTexto ?? Colors.white),
          ],
        ),
      ),
    );
  }
}
