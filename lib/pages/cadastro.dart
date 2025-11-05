import 'package:flutter/material.dart';
import 'dart:ui';

class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Setinha de voltar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFFFFFFF), // AppBar 
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        
      ),
      // Scroll para quando os campos ocuparem mais que a tela
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Título centralizado
              const Center(
                child: Text(
                  'Bem vindo ao\nSleepWell!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center
                ),
              ),
              const SizedBox(height: 40),

              // --- Campo Nome ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda padrão
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda quando não está focado
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 0, 30, 54)), // borda quando o campo está focado
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Campo Sobrenome ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Sobrenome', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda padrão
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda quando não está focado
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 0, 30, 54)), // borda quando o campo está focado
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Campo Email ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda padrão
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda quando não está focado
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 0, 30, 54)), // borda quando o campo está focado
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Campo Confirmar Email ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Confirmar Email', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda padrão
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda quando não está focado
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 0, 30, 54)), // borda quando o campo está focado
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Campo Senha ---
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 2),
                child: Text('Senha', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextField(
                obscureText: true, // oculta a senha
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda padrão
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda quando não está focado
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 0, 30, 54)), // borda quando o campo está focado
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
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda padrão
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 221, 221, 221)), // borda quando não está focado
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 0, 30, 54)), // borda quando o campo está focado
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Botão Cadastrar centralizado
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Aqui você vai para a tela de sucesso
                    // Ex: Navigator.push(context, MaterialPageRoute(builder: (context) => SucessoPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 25, 44, 80), // azul escuro
                    minimumSize: const Size.fromHeight(60), // altura do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // borda arredondada igual aos TextFields
                    ),
                  ),
                  child: const Text('Cadastrar', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
