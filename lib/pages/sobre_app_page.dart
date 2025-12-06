import 'package:flutter/material.dart';

class SobreAppPage extends StatelessWidget {
  const SobreAppPage({super.key});

  final Color _primaryColor = const Color(0xFF0B2A4A);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _textColor = const Color(0xFF333333);

  final String appVersion = "1.0.0";
  final String buildNumber = "10";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Sobre",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Icon(
                  Icons.hotel_rounded,
                  size: 60,
                  color: _primaryColor,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "SleepWell",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 5),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Versão $appVersion ($buildNumber)",
                  style: TextStyle(
                    fontSize: 14,
                    color: _primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "O SleepWell é a solução definitiva para encontrar e reservar as melhores estadias. Nossa missão é proporcionar conforto, segurança e facilidade na palma da sua mão.\n Desenvolvido por uma equipe de apaixonados por viagens e tecnologia, alunos do curso de Análise e Desenvolvimento de Sistemas do IFBA - Campus Guanambi.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              _buildInfoTile(
                icon: Icons.description_outlined,
                text: "Termos de Uso",
                onTap: () {},
              ),
              const SizedBox(height: 15),

              _buildInfoTile(
                icon: Icons.privacy_tip_outlined,
                text: "Política de Privacidade",
                onTap: () {},
              ),
              const SizedBox(height: 15),

              _buildInfoTile(
                icon: Icons.star_outline_rounded,
                text: "Avalie o App",
                onTap: () {},
              ),
              const SizedBox(height: 15),

              _buildInfoTile(
                icon: Icons.language,
                text: "Visite nosso site",
                onTap: () {},
              ),

              const SizedBox(height: 50),

              Text(
                "© 2025 SleepWell Inc.\nTodos os direitos reservados. \n Andson Queiroz, Paulo José e Ana Clara Marques",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[400]),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: _primaryColor, size: 22),
                const SizedBox(width: 15),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _textColor,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
