import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;

  @override
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
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 30),

              // --- Campo Sobrenome ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Sobrenome', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 30),

              // --- Campo Email ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
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
                  onPressed: () {
                    // Aqui você vai para a tela de sucesso
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
