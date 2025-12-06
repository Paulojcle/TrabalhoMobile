import 'package:flutter/material.dart';
import '../servicos/auth_service.dart';
import 'check_email.dart';

class RecuperacaoSenha extends StatefulWidget {
  const RecuperacaoSenha({super.key});

  @override
  State<RecuperacaoSenha> createState() => _RecuperacaoSenhaState();
}

class _RecuperacaoSenhaState extends State<RecuperacaoSenha> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _enviarEmailRecuperacao() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Digite seu email.")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Chama o serviço
    String? erro = await AuthService().redefinirSenha(email: email);

    setState(() {
      _isLoading = false;
    });

    if (erro == null) {
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChecarEmail()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recuperar Senha',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Informe seu email associado à sua conta e nós iremos enviar um email com instruções para redefinir sua senha',
                    style: TextStyle(fontSize: 15, color: Color(0xFF7F7F7F)),
                  ),
                  const SizedBox(height: 50),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'email@email.com',
                      hintStyle: const TextStyle(
                        color: Color(0xFF7F7F7F),
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 221, 221, 221),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 221, 221, 221),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 30, 54),
                        ),
                      ),
                      suffixIcon: const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.email, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _enviarEmailRecuperacao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 25, 44, 80),
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Recuperar senha',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
