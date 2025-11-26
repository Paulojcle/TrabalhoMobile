import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bed),
            label: "Quartos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Configurações",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Perfil",
          ),
        ],
      ),
      body: Stack(
        children: [
          // imagem de fundo desfocada
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

          // conteúdo principal
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

                
                  // card de login
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

                        // Usuário
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "Usuário:",
                              contentPadding: EdgeInsets.all(12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Senha
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Senha:",
                              contentPadding: EdgeInsets.all(12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Links
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Esqueceu a senha?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
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
