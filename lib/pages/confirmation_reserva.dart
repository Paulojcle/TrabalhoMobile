import 'package:flutter/material.dart';

class ConfirmacaoReserva extends StatelessWidget {
  const ConfirmacaoReserva({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Arte + texto centralizados
              Column(
                children: const [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 250,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Reserva realizada com sucesso!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 51, 51, 51)
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // Botão fixo na parte inferior
              SizedBox(
                width: double.infinity,
                height: 55,
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
                    'Ver detalhes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
