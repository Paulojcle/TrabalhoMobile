import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../servicos/auth_service.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  String selectedLanguage = 'pt';
  bool soundEffects = true;
  bool darkMode = false;
  
  // Variável de estado para controlar a exibição dos botões
  bool _isLoggedIn = false; 

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); 
  }

  // Verifica o estado de login do Firebase e atualiza o widget
  void _checkLoginStatus() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isLoggedIn = user != null;
    });
  }

  // === FUNÇÃO AUXILIAR PARA O DIÁLOGO DE CONFIRMAÇÃO ===

  Future<bool> _showConfirmationDialog(BuildContext context, String title, String content) async {
    // showDialog retorna o valor passado no Navigator.pop, ou null se for fechado externamente.
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Não
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Sim (Ação)
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ?? false; // Garante que retorna false se o diálogo for fechado
  }

  // === Funções de Ação ===
  
  void _handleLogout() async {
    final confirmed = await _showConfirmationDialog(
      context,
      "Fazer Logout?",
      "Você deseja realmente sair da sua conta?",
    );
    
    if (!confirmed) return; // Se o usuário cancelar, a função para aqui.

    await AuthService().signOut();
    _checkLoginStatus(); 
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Você saiu da sua conta.")),
    );
  }

  void _handleDeleteAccount() async {
    final confirmed = await _showConfirmationDialog(
      context,
      "Excluir Conta Permanentemente?",
      "Atenção! Você realmente deseja excluir sua conta? Esta ação é irreversível e apagará todos os seus dados.",
    );
    
    if (!confirmed) return; // Se o usuário cancelar, a função para aqui.
    
    String? erro = await AuthService().deleteUser();
    
    if (erro == null) {
      _checkLoginStatus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Conta excluída com sucesso.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao excluir conta: $erro")),
      );
    }
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(height: 10),

            // ========= ÍCONE CENTRAL =========
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(),
                    child: const Icon(
                      Icons.settings,
                      size: 55,
                      color: Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Configurações",
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 51, 51, 51)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ========= IDIOMA, EFEITOS SONOROS, MODO ESCURO =========
            
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
            
            // ========= AJUDA E SOBRE (Botões fixos) =========
            _buildButtonCard(
              icon: Icons.help_outline,
              text: "Ajuda",
              onTap: () {},
            ),
            const SizedBox(height: 15),
            _buildButtonCard(
              icon: Icons.info_outline,
              text: "Sobre",
              onTap: () {},
            ),
            const SizedBox(height: 15),
            

            // ========= EXCLUIR CONTA (CONDICIONAL) =========
            if (_isLoggedIn)
              _buildButtonCard(
                icon: Icons.delete_outline,
                text: "Excluir Conta",
                color: Colors.red,
                onTap: _handleDeleteAccount, // Chama a função de exclusão
              ),
              
            if (_isLoggedIn) const SizedBox(height: 15),

            // ========= SAIR (CONDICIONAL) =========
            if (_isLoggedIn)
              _buildButtonCard(
                icon: Icons.logout,
                text: "Sair",
                color: Colors.black,
                onTap: _handleLogout, // Chama a função de sair
              ),
              
            const SizedBox(height: 15),
          ],
        ),
      )
    );
  }
}