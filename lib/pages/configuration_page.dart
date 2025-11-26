import 'package:flutter/material.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  String selectedLanguage = 'pt';
  bool soundEffects = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 10),

          // ========= ÍCONE CENTRAL =========
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(),
                  child: const Icon(
                    Icons.settings,
                    size: 40,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Configurações",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ========= IDIOMA =========
          _buildCard(
            title: "Idioma",
            child: DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'pt',
                  child: Text("Português (Brasil)"),
                ),
                DropdownMenuItem(value: 'en', child: Text("Inglês (English)")),
                DropdownMenuItem(
                  value: 'es',
                  child: Text("Espanhol (Español)"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // ========= EFEITOS SONOROS =========
          _buildCard(
            title: "Efeitos Sonoros",
            child: SwitchListTile(
              value: soundEffects,
              title: const Text("Ativar sons do aplicativo"),
              onChanged: (value) {
                setState(() {
                  soundEffects = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // ========= MODO ESCURO =========
          _buildCard(
            title: "Modo Escuro",
            child: SwitchListTile(
              value: darkMode,
              title: const Text("Ativar modo escuro"),
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // ========= AJUDA =========
          _buildButtonCard(
            icon: Icons.help_outline,
            text: "Ajuda",
            onTap: () {},
          ),

          const SizedBox(height: 15),

          // ========= SOBRE =========
          _buildButtonCard(
            icon: Icons.info_outline,
            text: "Sobre",
            onTap: () {},
          ),

          const SizedBox(height: 15),

          // ========= EXCLUIR CONTA =========
          _buildButtonCard(
            icon: Icons.delete_outline,
            text: "Excluir Conta",
            color: Colors.red,
            onTap: () {},
          ),

          const SizedBox(height: 15),

          // ========= SAIR =========
          _buildButtonCard(
            icon: Icons.logout,
            text: "Sair",
            color: Colors.black,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ------------ COMPONENTE REUTILIZÁVEL: CARD DE CONFIGURAÇÃO ------------
  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // ------------ COMPONENTE PARA BOTÕES COMO AJUDA, SOBRE, SAIR ------------
  Widget _buildButtonCard({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
