import 'package:flutter/material.dart';

class Textos extends StatelessWidget {
  final String meuTexto;
  final Color cores;

  // 🧠 Novas opções de estilização
  final double tamanhoFonte;
  final FontWeight pesoFonte;
  final TextAlign alinhamento;
  final FontStyle estiloFonte;
  final Color? corFundo;
  final TextDecoration? decoracao;
  final double? espacoEntreLetras;
  final double? espacoEntreLinhas;
  final String? fontePersonalizada;
  final List<Shadow>? sombras;
  final EdgeInsetsGeometry? padding;
  final TextOverflow? overflow;
  final int? maxLinhas;

  const Textos(
      this.meuTexto,
      this.cores, {
        super.key,
        this.tamanhoFonte = 35,
        this.pesoFonte = FontWeight.bold,
        this.alinhamento = TextAlign.center,
        this.estiloFonte = FontStyle.normal,
        this.corFundo = Colors.transparent,
        this.decoracao,
        this.espacoEntreLetras,
        this.espacoEntreLinhas,
        this.fontePersonalizada,
        this.sombras,
        this.padding,
        this.overflow,
        this.maxLinhas,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(4.0),
      child: Text(
        meuTexto,
        textAlign: alinhamento,
        maxLines: maxLinhas,
        overflow: overflow,
        style: TextStyle(
          color: cores,
          backgroundColor: corFundo,
          fontSize: tamanhoFonte,
          fontWeight: pesoFonte,
          fontStyle: estiloFonte,
          decoration: decoracao,
          letterSpacing: espacoEntreLetras,
          height: espacoEntreLinhas,
          fontFamily: fontePersonalizada,
          shadows: sombras,
        ),
      ),
    );
  }
}
