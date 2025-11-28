import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'recuperacao_senha.dart';
import '../servicos/auth_service.dart';
import 'package:hotel_app/main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Controladores de Texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // 2. Lógica de Autenticação (Mantida idêntica)
  void _fazerLogin(BuildContext context) async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha o email e a senha.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? res = await AuthService().signInUser(email: email, senha: senha);

    setState(() {
      _isLoading = false;
    });

    if (res != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res)),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(indexInicial: 0),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pega o tamanho da tela para cálculos de proporção
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // resizeToAvoidBottomInset: false impede que a imagem de fundo esprema quando o teclado abre
      resizeToAvoidBottomInset: false, 
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. IMAGEM DE FUNDO (Ocupa a tela toda)
          Positioned.fill(
            child: Image.network(
              "https://images.pexels.com/photos/271639/pexels-photo-271639.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          
          // 1.1 Overlay escuro para melhorar o contraste do botão de voltar (Opcional)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),

          // 2. BOTÃO DE VOLTAR (Customizado)
          Positioned(
            top: 50, // Margem segura do topo
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          // 3. TÍTULO GRANDE NO FUNDO (Opcional, dá um charme moderno)
          const Positioned(
            top: 120,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bem-vindo\nde volta!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 2))
                    ]
                  ),
                ),
              ],
            ),
          ),

          // 4. O MODAL BRANCO (Fica embaixo e sobe até ~60% da tela)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.60, // Ocupa 60% da altura da tela
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: Offset(0, -5),
                  )
                ],
              ),
              child: Padding(
                // Padding para o conteúdo não colar nas bordas
                // e EdgeInsets.only(bottom: ...) para lidar com teclado se necessário
                padding: EdgeInsets.only(
                  left: 30, 
                  right: 30, 
                  top: 40,
                  bottom: MediaQuery.of(context).viewInsets.bottom // Empurra conteúdo com teclado
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      const Text(
                        "Faça seu Login",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B2A4A),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // CAMPO EMAIL
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "exemplo@email.com",
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF0B2A4A)),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFF0B2A4A), width: 1.5),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      // CAMPO SENHA
                      TextField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          hintText: "********",
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF0B2A4A)),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFF0B2A4A), width: 1.5),
                          ),
                        ),
                      ),

                      // LINK ESQUECEU A SENHA
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RecuperacaoSenha()),
                            );
                          },
                          child: const Text(
                            "Esqueceu a senha?",
                            style: TextStyle(
                              color: Color(0xFF0B2A4A),
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // BOTÃO ENTRAR
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () => _fazerLogin(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B2A4A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                )
                              : const Text(
                                  "ENTRAR",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // LINK CADASTRO
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Não tem conta? ",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CadastroPage()),
                              );
                            },
                            child: const Text(
                              "Cadastre-se",
                              style: TextStyle(
                                color: Color(0xFF0B2A4A),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Espaço extra para garantir que role bem em telas pequenas
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}