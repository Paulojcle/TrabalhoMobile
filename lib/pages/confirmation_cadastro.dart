import 'package:flutter/material.dart';
import 'package:hotel_app/main_screen.dart';

class ConfirmacaoCadastro extends StatelessWidget {
  const ConfirmacaoCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            children: [
              
              // Empurra o conteúdo para o centro
              const Spacer(), 

              // --- ÁREA DE SUCESSO ---
              Column(
                children: [
                  // Ícone com fundo circular (Estilo moderno)
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1), // Fundo verde bem clarinho
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 100, // Tamanho equilibrado
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  const Text(
                    'Tudo pronto!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B2A4A), // Cor da marca
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 15),
                  
                  const Text(
                    'Seu cadastro foi realizado com sucesso.\nAgora você pode aproveitar o SleepWell.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey, // Texto secundário mais suave
                      height: 1.5, // Espaçamento entre linhas
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // Empurra o botão para o final
              const Spacer(), 

              // --- BOTÃO DE AÇÃO ---
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(indexInicial: 0),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B2A4A),
                    elevation: 5, // Sombra sutil
                    shadowColor: const Color(0xFF0B2A4A).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Bordas modernas
                    ),
                  ),
                  child: const Text(
                    'Começar a explorar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20), // Margem inferior extra
            ],
          ),
        ),
      ),
    );
  }
}