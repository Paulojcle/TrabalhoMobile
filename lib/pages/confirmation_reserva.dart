import 'package:flutter/material.dart';
import 'package:hotel_app/main_screen.dart';
import '../data/reserva_service.dart';
import 'detalhes_reserva.dart';

class ConfirmacaoReserva extends StatelessWidget {
  final String reservaID;
  final ReservaService reservaService;

  const ConfirmacaoReserva({
    super.key,
    required this.reservaID,
    required this.reservaService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            children: [
              const Spacer(),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 100,
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Reserva Confirmada!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B2A4A),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Sua reserva foi realizada com sucesso.\n',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesReservaPage(
                          reservaID: reservaID,
                          reservaService: reservaService,
                        ),
                      ),
                      // Remove rotas até a rota raiz (MainScreen)
                      (Route<dynamic> route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B2A4A),
                    elevation: 5,
                    shadowColor: const Color(0xFF0B2A4A).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Ver detalhes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MainScreen(indexInicial: 0),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Voltar à tela inicial',
                      style: TextStyle(color: Color(0xFF0B2A4A), fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
