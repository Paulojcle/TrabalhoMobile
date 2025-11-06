import 'package:flutter/material.dart';

class RecuperacaoSenha extends StatelessWidget {
  const RecuperacaoSenha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(
                'Recuperar Senha',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 51, 51, 51)
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Informe seu email associado à sua conta e nós iremos enviar um email com instruções para redefinir sua senha',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF7F7F7F)
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                    decoration: InputDecoration(
                      hintText: 'email@email.com',
                      hintStyle: TextStyle(color: Color(0xFF7F7F7F), fontSize: 14), // texto cinza
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
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 20), // afasta o ícone da borda
                        child: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
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
                      child: const Text('Recuperar senha', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              )
            ],

          ),
          ),
        ),
    );
  }
}