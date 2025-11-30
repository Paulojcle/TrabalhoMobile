import 'package:flutter/material.dart';
import 'package:hotel_app/servicos/auth_service.dart';
import 'confirmation_cadastro.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmarEmailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  // Cor principal do tema
  final Color _primaryColor = const Color(0xFF0B2A4A);

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _emailController.dispose();
    _confirmarEmailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        
        // === CORREÇÃO DO APPBAR ===
        backgroundColor: Colors.white, // Fundo branco
        surfaceTintColor: Colors.transparent, // Remove a cor "estranha" do Material 3
        elevation: 0, // Começa sem sombra
        scrolledUnderElevation: 4.0, // Adiciona sombra suave ao rolar
        shadowColor: Colors.black.withOpacity(0.5), // Define a cor da sombra (opcional)
        // ==========================
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título Grande e Moderno
              Text(
                'Crie sua conta',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Preencha seus dados para começar a explorar.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // --- SEÇÃO 1: DADOS PESSOAIS ---
              _buildSectionTitle("Dados Pessoais"),
              const SizedBox(height: 20),
              
              _buildTextField(
                label: "Nome",
                controller: _nomeController,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: "Sobrenome",
                controller: _sobrenomeController,
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 30),

              // --- SEÇÃO 2: CONTATO ---
              _buildSectionTitle("Contato"),
              const SizedBox(height: 20),

              _buildTextField(
                label: "Email",
                controller: _emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: "Confirmar Email",
                controller: _confirmarEmailController,
                icon: Icons.mark_email_read_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30),

              // --- SEÇÃO 3: SEGURANÇA ---
              _buildSectionTitle("Segurança"),
              const SizedBox(height: 20),

              // Campo Senha
              TextField(
                obscureText: _obscureSenha,
                controller: _senhaController,
                decoration: _inputDecoration("Senha", Icons.lock_outline).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureSenha ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscureSenha = !_obscureSenha),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo Confirmar Senha
              TextField(
                obscureText: _obscureConfirmarSenha,
                controller: _confirmarSenhaController,
                decoration: _inputDecoration("Confirmar Senha", Icons.lock_reset).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmarSenha ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscureConfirmarSenha = !_obscureConfirmarSenha),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // BOTÃO CADASTRAR
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    _handleCadastro();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: _primaryColor.withOpacity(0.3),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // === FUNÇÕES DE LÓGICA E UI ===

  Future<void> _handleCadastro() async {
    String nome = _nomeController.text.trim();
    String sobrenome = _sobrenomeController.text.trim();
    String email = _emailController.text.trim();
    String confirmarEmail = _confirmarEmailController.text.trim();
    String senha = _senhaController.text.trim();
    String confirmarSenha = _confirmarSenhaController.text.trim();

    if (nome.isEmpty || sobrenome.isEmpty || email.isEmpty || senha.isEmpty) {
      _showSnackBar("Preencha todos os campos!");
      return;
    }

    if (email != confirmarEmail) {
      _showSnackBar("Os emails não coincidem");
      return;
    }

    if (senha != confirmarSenha) {
      _showSnackBar("As senhas não coincidem");
      return;
    }

    String? res = await AuthService().registerUser(
      nome: nome,
      sobrenome: sobrenome,
      email: email,
      senha: senha,
      cpf: '',
      telefone: '',
      dataNascimento: '',
      fotoUrl: null,
    );

    if (res != null) {
      _showSnackBar(res);
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConfirmacaoCadastro()),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey[500],
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]),
      prefixIcon: Icon(icon, color: _primaryColor),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: _primaryColor, width: 1.5),
      ),
    );
  }
}