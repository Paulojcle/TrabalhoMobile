import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'recuperacao_senha.dart';
import '../servicos/auth_service.dart'; // Importe o seu AuthService

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

  // 2. Lógica de Autenticação
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

    // Chama o serviço de autenticação
    String? res = await AuthService().signInUser(email: email, senha: senha);

    setState(() {
      _isLoading = false;
    });

    if (res != null) {
      // Erro: Mostra a mensagem do Firebase/AuthService
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res)),
      );
    } else {
      // Sucesso: Fecha a LoginPage e retorna para a MainScreen
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // === APPBAR PARA O BOTÃO DE VOLTAR ===
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true, // Permite que o corpo suba atrás da barra
            
      body: Stack(
        children: [
          // 1. Imagem de fundo desfocada
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Opacity(
              opacity: 0.35,
              child: Image.network(
                "https://images.pexels.com/photos/271639/pexels-photo-271639.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Conteúdo principal (Scrollable)
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
              child: Column(
                children: [
                  // LOGO
                  Column(
                    children: [
                      Image.network(
                        "https://cdn-icons-png.flaticon.com/512/3104/3104952.png",
                        height: 80,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "SleepWell",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B2A4A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                
                  // Card de login
                  Container(
                    padding: const EdgeInsets.all(25),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B2A4A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Usuário (TextField) - Com Controller
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TextField(
                            controller: _emailController, // Adiciona o controller
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Email:", // Mudança para Email
                              contentPadding: EdgeInsets.all(12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Senha (TextField) - Com Controller
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TextField(
                            controller: _senhaController, // Adiciona o controller
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "Senha:",
                              contentPadding: EdgeInsets.all(12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // BOTÃO LOGIN (CHAMA O _fazerLogin)
                        ElevatedButton(
                          onPressed: _isLoading ? null : () => _fazerLogin(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0B2A4A),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0B2A4A)),
                                )
                              : const Text(
                                  "ENTRAR",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),

                        const SizedBox(height: 15),

                        // Links
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Redirecionamento para a página de recuperação de senha
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RecuperacaoSenha(),
                                  ),
                                );
                                
                              },
                              child: const Text(
                                "Esqueceu a senha?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Redirecionamento para cadastro
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CadastroPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Cadastre-se",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}