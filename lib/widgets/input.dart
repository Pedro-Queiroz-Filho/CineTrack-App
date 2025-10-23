import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String rotulo;
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType tipoTeclado;
  final Color? corTexto;
  final Color? corFundo;
  final Color? corBorda;
  final double raioBorda;
  final IconData? icone;
  final String? erroTexto;
  final TextStyle? estiloLabel;
  final EdgeInsetsGeometry? padding;

  const Input(
      this.rotulo,
      this.label, {
        super.key,
        required this.controller,
        this.obscureText = false,
        this.tipoTeclado = TextInputType.text,
        this.corTexto,
        this.corFundo,
        this.corBorda,
        this.raioBorda = 12.0,
        this.icone,
        this.erroTexto,
        this.estiloLabel,
        this.padding,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: tipoTeclado,
        style: TextStyle(
          color: corTexto ?? Colors.black,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: corFundo ?? Colors.white,
          labelText: label,
          hintText: rotulo,
          hintStyle: TextStyle(color: Colors.grey[600]),
          labelStyle: estiloLabel ??
              TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
          prefixIcon: icone != null ? Icon(icone, color: Colors.blueAccent) : null,
          errorText: erroTexto,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(raioBorda),
            borderSide: BorderSide(color: corBorda ?? Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(raioBorda),
            borderSide: BorderSide(color: corBorda ?? Colors.blueAccent, width: 2),
          ),
        ),
      ),
    );
  }
}
