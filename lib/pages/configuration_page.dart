import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../servicos/auth_service.dart';
import 'sobre_app_page.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  String selectedLanguage = 'pt';
  bool soundEffects = true;
  bool darkMode = false;
  
  bool _isLoggedIn = false; 

  // Definição de cores do tema para consistência
  final Color _primaryColor = const Color(0xFF192C50); // Azul escuro elegante
  final Color _backgroundColor = const Color(0xFFF8F9FA); // Cinza muito claro (quase branco)
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF333333);

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); 
  }

  void _checkLoginStatus() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isLoggedIn = user != null;
    });
  }

  // === FUNÇÃO AUXILIAR PARA O DIÁLOGO DE CONFIRMAÇÃO ===
  Future<bool> _showConfirmationDialog(BuildContext context, String title, String content, {bool isDestructive = false}) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
        content: Text(content, style: const TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive ? Colors.redAccent : _primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
  }

  // === Funções de Ação ===
  void _handleLogout() async {
    final confirmed = await _showConfirmationDialog(
      context,
      "Fazer Logout?",
      "Você deseja realmente sair da sua conta?",
    );
    
    if (!confirmed) return;

    await AuthService().signOut();
    _checkLoginStatus(); 
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Você saiu da sua conta.")),
      );
    }
  }

  void _handleDeleteAccount() async {
    final confirmed = await _showConfirmationDialog(
      context,
      "Excluir Conta?",
      "Esta ação é irreversível e apagará todos os seus dados.",
      isDestructive: true,
    );
    
    if (!confirmed) return;
    
    String? erro = await AuthService().deleteUser();
    
    if (mounted) {
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
  }

  // ------------ COMPONENTE REUTILIZÁVEL: CARD DE CONFIGURAÇÃO ------------
  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), // Sombra muito suave
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _cardColor,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1), // Fundo suave para o ícone
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]), // Seta indicativa
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            const SizedBox(height: 10),

            // ========= ÍCONE CENTRAL E TÍTULO =========
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.08), // Círculo decorativo
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.settings_rounded, // Ícone arredondado
                      size: 40,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Configurações",
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: _textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // ========= IDIOMA =========
            _buildCard(
              title: "Preferências",
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedLanguage,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.language, color: Colors.grey),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    dropdownColor: Colors.white,
                    style: TextStyle(color: _textColor, fontSize: 15),
                    items: const [
                      DropdownMenuItem(value: 'pt', child: Text("Português (Brasil)")),
                      DropdownMenuItem(value: 'en', child: Text("Inglês (English)")),
                      DropdownMenuItem(value: 'es', child: Text("Espanhol (Español)")),
                    ],
                    onChanged: (value) => setState(() => selectedLanguage = value!),
                  ),
                  const SizedBox(height: 12),
                  // Efeitos Sonoros
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: _primaryColor,
                    value: soundEffects,
                    title: Text("Efeitos Sonoros", style: TextStyle(color: _textColor, fontWeight: FontWeight.w500)),
                    onChanged: (value) => setState(() => soundEffects = value),
                  ),
                  // Modo Escuro
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: _primaryColor,
                    value: darkMode,
                    title: Text("Modo Escuro", style: TextStyle(color: _textColor, fontWeight: FontWeight.w500)),
                    onChanged: (value) => setState(() => darkMode = value),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            
            // ========= AJUDA E SOBRE =========
            _buildButtonCard(
              icon: Icons.help_outline_rounded,
              text: "Ajuda e Suporte",
              color: _primaryColor,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildButtonCard(
              icon: Icons.info_outline_rounded,
              text: "Sobre o App",
              color: _primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SobreAppPage()),
                );
              },
            ),

            if (_isLoggedIn) ...[
              const SizedBox(height: 30),
              // ========= AÇÕES DA CONTA =========
              _buildButtonCard(
                icon: Icons.logout_rounded,
                text: "Sair da Conta",
                color: _textColor,
                onTap: _handleLogout,
              ),
              const SizedBox(height: 12),
              _buildButtonCard(
                icon: Icons.delete_outline_rounded,
                text: "Excluir Conta",
                color: Colors.redAccent,
                onTap: _handleDeleteAccount,
              ),
            ],
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}