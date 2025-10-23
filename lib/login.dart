import 'package:flutter/material.dart';
import '../widgets/input.dart';
import '../widgets/texto.dart';
import '../widgets/botoes.dart';
import '../widgets/imagens.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  // 🎨 Cor principal inspirada no IMDb
  final Color imdbYellow = const Color(0xFFF5C518);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Tema escuro
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Logo no canto superior esquerdo
            Positioned(
              top: 20,
              left: 20,
              child: SuaImagem(
                caminhoArquivo: "imagens/logo.png",
                largura: 70,
                altura: 70,
                bordaArredondada: 12,
                corFundo: Colors.transparent,
                sombras: [
                  BoxShadow(
                    color: imdbYellow.withOpacity(0.6),
                    blurRadius: 10,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
            ),

            // 🔹 Conteúdo central
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100), // espaço para logo
                    Textos(
                      "CineTrack",
                      imdbYellow,
                      tamanhoFonte: 36,
                      pesoFonte: FontWeight.bold,
                      alinhamento: TextAlign.center,
                      sombras: [
                        Shadow(
                          color: imdbYellow.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),

                    // Campo de E-mail
                    Input(
                      "Digite seu e-mail",
                      "E-mail",
                      controller: emailController,
                      corTexto: Colors.white,
                      corFundo: const Color(0xFF1A1A1A),
                      corBorda: imdbYellow,
                      icone: Icons.email_outlined,
                      estiloLabel: TextStyle(color: imdbYellow),
                      raioBorda: 12.0,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    const SizedBox(height: 25),

                    // Campo de Senha
                    Input(
                      "Digite sua senha",
                      "Senha",
                      controller: senhaController,
                      obscureText: true,
                      corTexto: Colors.white,
                      corFundo: const Color(0xFF1A1A1A),
                      corBorda: imdbYellow,
                      icone: Icons.lock_outline,
                      estiloLabel: TextStyle(color: imdbYellow),
                      raioBorda: 12.0,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    const SizedBox(height: 40),

                    // Botão de Login
                    Botoes(
                      "Entrar",
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      largura: double.infinity,
                      altura: 55,
                      corFundo: imdbYellow,
                      corTexto: Colors.black,
                      corBorda: Colors.transparent,
                      raioBorda: 14.0,
                      sombras: [
                        BoxShadow(
                          color: imdbYellow.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Botão de Registrar
                    Botoes(
                      "Criar Conta",
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      largura: double.infinity,
                      altura: 55,
                      corFundo: Colors.black,
                      corTexto: imdbYellow,
                      corBorda: imdbYellow,
                      raioBorda: 14.0,
                    ),

                    const SizedBox(height: 40),

                    // Texto pequeno
                    Textos(
                      "© 2025 - Seu App",
                      Colors.grey,
                      tamanhoFonte: 14,
                      alinhamento: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
