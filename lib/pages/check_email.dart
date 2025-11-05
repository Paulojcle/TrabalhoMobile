import 'package:flutter/material.dart';

class ChecarEmail extends StatelessWidget {
  const ChecarEmail({super.key});

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
              // Arte + texto centralizados
              Column(
                children: const [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    color: Color(0xFF192C50),
                    size: 200,
                  ),
                  Text(
                    'Cheque seu email',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 51, 51, 51)
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Por favor, cheque o seu email. Nós iremos enviar um link de redefinição de senha.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 51, 51, 51)
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // Botão fixo na parte inferior
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Navegação
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 25, 44, 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Reenviar',
                    style: TextStyle(
                      color: Colors.white,
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
