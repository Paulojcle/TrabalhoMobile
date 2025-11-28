import 'package:flutter/material.dart';
import '../servicos/auth_service.dart';

class RedefinirSenhaPage extends StatefulWidget {
  // Recebe o código secreto vindo do link do email
  final String oobCode; 
  
  const RedefinirSenhaPage({super.key, required this.oobCode});

  @override
  State<RedefinirSenhaPage> createState() => _RedefinirSenhaPageState();
}

class _RedefinirSenhaPageState extends State<RedefinirSenhaPage> {
  final TextEditingController _senhaController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false; // Controle de carregamento

  // Variáveis de validação
  bool _hasMinLength = false;
  bool _hasLetters = false;
  bool _hasDigits = false;

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  void _validarSenha(String valor) {
    setState(() {
      _hasMinLength = valor.length >= 8;
      _hasLetters = valor.contains(RegExp(r'[a-zA-Z]'));
      _hasDigits = valor.contains(RegExp(r'[0-9]'));
    });
  }

  void _confirmarRedefinicao() async {
    if (_hasMinLength && _hasLetters && _hasDigits) {
      
      setState(() {
        _isLoading = true;
      });

      // Chama o AuthService passando o código recebido e a nova senha
      String? erro = await AuthService().confirmarRedefinicaoSenha(
        code: widget.oobCode, 
        newPassword: _senhaController.text
      );

      setState(() {
        _isLoading = false;
      });

      if (erro == null) {
        // Sucesso!
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Senha alterada com sucesso! Faça login.")),
        );
        // Remove tudo e volta para a tela de Login (rota '/') ou onde você definir
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        // Erro
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: $erro")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFormValid = _hasMinLength && _hasLetters && _hasDigits;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Criar nova senha',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0B2A4A)),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sua nova senha deve ser diferente das senhas utilizadas anteriormente.',
                style: TextStyle(fontSize: 15, color: Color(0xFF7F7F7F)),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _senhaController,
                obscureText: _obscureText,
                onChanged: _validarSenha,
                decoration: InputDecoration(
                  labelText: 'Nova Senha',
                  hintText: '********',
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF0B2A4A)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),

              const SizedBox(height: 25),

              // Requisitos
              _RequisitoItem(atendido: _hasMinLength, texto: "Pelo menos 8 caracteres"),
              _RequisitoItem(atendido: _hasLetters, texto: "Pelo menos uma letra"),
              _RequisitoItem(atendido: _hasDigits, texto: "Pelo menos um número"),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: (isFormValid && !_isLoading) ? _confirmarRedefinicao : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B2A4A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Redefinir Senha',
                        style: TextStyle(
                          color: isFormValid ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequisitoItem extends StatelessWidget {
  final bool atendido;
  final String texto;
  const _RequisitoItem({required this.atendido, required this.texto});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(atendido ? Icons.check_circle : Icons.circle_outlined, color: atendido ? Colors.green : Colors.grey, size: 20),
          const SizedBox(width: 10),
          Text(texto, style: TextStyle(color: atendido ? Colors.green[700] : Colors.grey, fontWeight: atendido ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}