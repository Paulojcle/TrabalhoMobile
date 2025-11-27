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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Bem vindo ao\nSleepWell!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // --- Campo Nome ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: _nomeController,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 30),

              // --- Campo Sobrenome ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Sobrenome', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: _sobrenomeController,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 30),

              // --- Campo Email ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: _emailController,
                decoration: _inputDecoration(),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),

              // --- Campo Confirmar Email ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Confirmar Email', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: _confirmarEmailController,
                decoration: _inputDecoration(),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),

              // --- Campo Senha ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Senha', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                obscureText: _obscureSenha,
                controller: _senhaController,
                decoration: _inputDecoration().copyWith(
                  suffixIcon: IconButton(
                    padding: const EdgeInsets.only(right: 20),
                    icon: Icon(
                      _obscureSenha ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureSenha = !_obscureSenha;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Campo Confirmar Senha ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Confirmar Senha', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                obscureText: _obscureConfirmarSenha,
                controller: _confirmarSenhaController,
                decoration: _inputDecoration().copyWith(
                  suffixIcon: IconButton(
                    padding: const EdgeInsets.only(right: 20),
                    icon: Icon(
                      _obscureConfirmarSenha ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmarSenha = !_obscureConfirmarSenha;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Botão Cadastrar centralizado
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String nome = _nomeController.text.trim();
                    String sobrenome = _sobrenomeController.text.trim();
                    String email = _emailController.text.trim();
                    String confirmarEmail = _confirmarEmailController.text.trim();
                    String senha = _senhaController.text.trim();
                    String confirmarSenha = _confirmarSenhaController.text.trim();

                    if (nome.isEmpty || sobrenome.isEmpty || email.isEmpty || senha.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Preencha todos os campos!")),
                      );
                      return;
                    }

                    if (email != confirmarEmail) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Os emails não coincidem")),
                      );
                      return;
                    }

                    if (senha != confirmarSenha) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("As senhas não coincidem")),
                      );
                      return;
                    }

                    String? res = await AuthService().registerUser(
                      nome: nome,
                      sobrenome: sobrenome,
                      email: email,
                      senha: senha,
                    );

                    if (res != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(res)),
                      );
                    } else {
                      // Cadastro bem-sucedido: redireciona para perfil
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ConfirmacaoCadastro()),
                      );
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 25, 44, 80),
                    minimumSize: const Size.fromHeight(60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Função para estilizar todos os campos ---
  InputDecoration _inputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color.fromARGB(255, 0, 30, 54)),
      ),
    );
  }
}
