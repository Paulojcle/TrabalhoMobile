import 'package:flutter/material.dart';
import '../servicos/auth_service.dart';

class AlterarSenhaPage extends StatefulWidget {
  const AlterarSenhaPage({super.key});

  @override
  State<AlterarSenhaPage> createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {
  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();

  bool _obscureSenhaAtual = true;
  bool _obscureNovaSenha = true;
  bool _isLoading = false;

  bool _hasMinLength = false;
  bool _hasLetters = false;
  bool _hasDigits = false;

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    super.dispose();
  }

  void _validarNovaSenha(String valor) {
    setState(() {
      _hasMinLength = valor.length >= 8;
      _hasLetters = valor.contains(RegExp(r'[a-zA-Z]'));
      _hasDigits = valor.contains(RegExp(r'[0-9]'));
    });
  }

  void _salvarNovaSenha() async {
    String senhaAtual = _senhaAtualController.text.trim();
    String novaSenha = _novaSenhaController.text.trim();

    if (senhaAtual.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Digite sua senha atual.")));
      return;
    }

    if (!(_hasMinLength && _hasLetters && _hasDigits)) {
      return;
    }

    setState(() => _isLoading = true);

    String? erro = await AuthService().alterarSenha(
      senhaAtual: senhaAtual,
      novaSenha: novaSenha,
    );

    setState(() => _isLoading = false);

    if (erro == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Senha alterada com sucesso!")),
      );
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro: $erro")));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFormValid =
        _hasMinLength &&
        _hasLetters &&
        _hasDigits &&
        _senhaAtualController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Alterar Senha",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                "Senha Atual",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _senhaAtualController,
                obscureText: _obscureSenhaAtual,
                decoration: _inputDecoration().copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureSenhaAtual
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(
                      () => _obscureSenhaAtual = !_obscureSenhaAtual,
                    ),
                  ),
                ),
                onChanged: (val) => setState(() {}),
              ),

              const SizedBox(height: 25),

              const Text(
                "Nova Senha",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _novaSenhaController,
                obscureText: _obscureNovaSenha,
                onChanged: _validarNovaSenha,
                decoration: _inputDecoration().copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNovaSenha
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _obscureNovaSenha = !_obscureNovaSenha),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Requsitos da senha
              const Text(
                "A nova senha deve conter:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              _RequisitoItem(
                atendido: _hasMinLength,
                texto: "Pelo menos 8 caracteres",
              ),
              _RequisitoItem(
                atendido: _hasLetters,
                texto: "Pelo menos uma letra",
              ),
              _RequisitoItem(
                atendido: _hasDigits,
                texto: "Pelo menos um número",
              ),

              const SizedBox(height: 40),

              // botão salvar
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: (isFormValid && !_isLoading)
                      ? _salvarNovaSenha
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B2A4A),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Salvar Alterações',
                          style: TextStyle(
                            color: Colors.white,
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: '********',
      hintStyle: const TextStyle(color: Color(0xFF7F7F7F)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF0B2A4A)),
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
          Icon(
            atendido ? Icons.check_circle : Icons.circle_outlined,
            color: atendido ? Colors.green : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            texto,
            style: TextStyle(
              color: atendido ? Colors.green[700] : Colors.grey,
              fontSize: 13,
              fontWeight: atendido ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
