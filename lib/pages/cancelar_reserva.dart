import 'package:flutter/material.dart';
import '../data/reserva_service.dart';

class CancelarReserva extends StatelessWidget {
  final String reservaID;
  final ReservaService reservaService;

  // Adicionando os parâmetros necessários para a lógica real
  const CancelarReserva({
    super.key,
    required this.reservaID,
    required this.reservaService,
  });

  // Função para lidar com o cancelamento
  Future<void> _handleCancelamento(BuildContext context) async {
    try {
      await reservaService.cancelarReserva(reservaID);

      // Sucesso: Retorna para a MainScreen e mostra uma notificação
      if (context.mounted) {
        Navigator.of(context).popUntil(
          (route) => route.isFirst,
        ); // Volta para a tela principal (MainScreen)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Reserva cancelada com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Falha: Mostra o erro
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Erro ao cancelar a reserva: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color dangerColor = Colors.red.shade700;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cancelar Reserva"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Ícone de Aviso Grande
              Icon(Icons.warning_amber_rounded, color: dangerColor, size: 80),
              const SizedBox(height: 20),

              // 2. Título de Alerta
              const Text(
                "Atenção!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // 3. Mensagem Principal (com ID da Reserva)
              Text(
                "Tem certeza que deseja cancelar a reserva ID: $reservaID? Esta ação não pode ser desfeita.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // 4. Botão de Confirmação (Perigo)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text(
                    "SIM, CANCELAR RESERVA",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () => _handleCancelamento(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dangerColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 5. Botão Secundário (Manter)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Simplesmente volta para a DetalhesReservaPage
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Manter Reserva",
                    style: TextStyle(fontSize: 16, color: primaryColor),
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
