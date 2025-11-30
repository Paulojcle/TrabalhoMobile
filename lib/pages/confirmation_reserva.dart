import 'package:flutter/material.dart';
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
                    color: Color.fromARGB(255, 51, 51, 51),
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
                  // ⬅️ CORREÇÃO: Usando pushAndRemoveUntil
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalhesReservaPage(
                        reservaID: reservaID,
                        reservaService: reservaService,
                      ),
                    ),
                    // Predicado: Remove rotas até a rota raiz (MainScreen)
                    (Route<dynamic> route) => route.isFirst,
                  );
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
                    fontWeight: FontWeight.bold,
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
