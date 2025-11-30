import 'package:flutter/material.dart';
import 'package:hotel_app/models/reserva.dart';
import 'package:hotel_app/models/quarto.dart';
import '../data/reserva_service.dart';
import 'cancelar_reserva.dart';

class DetalhesReservaPage extends StatefulWidget {
  final String reservaID;
  final ReservaService reservaService;

  const DetalhesReservaPage({
    super.key,
    required this.reservaID,
    required this.reservaService,
  });

  @override
  State<DetalhesReservaPage> createState() => _DetalhesReservaPageState();
}

class _DetalhesReservaPageState extends State<DetalhesReservaPage> {
  late Future<(Reserva, Quarto)> _futureDetalhes;
  
  // Cores do Tema
  final Color _primaryColor = const Color(0xFF0B2A4A);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF333333);

  @override
  void initState() {
    super.initState();
    _futureDetalhes = _carregarDetalhes();
  }

  Future<(Reserva, Quarto)> _carregarDetalhes() async {
    final reserva = await widget.reservaService.buscarReservaPorId(widget.reservaID);
    final quartos = await widget.reservaService.buscarTodosQuartos();
    final quarto = quartos.firstWhere(
      (q) => q.id == reserva.quartoId,
      orElse: () => throw Exception('Quarto não encontrado.'),
    );
    return (reserva, quarto);
  }

  String _formatarData(DateTime data) => '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  String _formatarMoeda(double valor) => 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';

  double _calcularValorTotal(Reserva reserva, Quarto quarto) {
    final numDiarias = reserva.dataSaida.difference(reserva.dataEntrada).inDays;
    return quarto.preco * (numDiarias > 0 ? numDiarias : 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Minha Reserva', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<(Reserva, Quarto)>(
        future: _futureDetalhes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: _primaryColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}', style: TextStyle(color: Colors.red[300])));
          }

          final (reserva, quarto) = snapshot.data!;
          final valorTotal = _calcularValorTotal(reserva, quarto);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                // === STATUS DA RESERVA ===
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 16, color: Colors.green),
                      SizedBox(width: 6),
                      Text("Confirmada", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // === IMAGEM E NOME DO QUARTO ===
                Container(
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 50, color: Colors.grey), // Placeholder
                          // Aqui entraria a imagem real: Image.network(quarto.imagemUrl...)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quarto.tipo,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.location_on_rounded, size: 16, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Text(
                                  quarto.descricao, // Usando descrição como local/info
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // === DETALHES DA ESTADIA ===
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Check-in / Check-out Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDateColumn("Check-in", _formatarData(reserva.dataEntrada)),
                          Icon(Icons.arrow_forward_rounded, color: Colors.grey[300]),
                          _buildDateColumn("Check-out", _formatarData(reserva.dataSaida)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1),
                      const SizedBox(height: 20),
                      
                      // Hóspedes e ID
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoRow(Icons.people_alt_rounded, "${reserva.numHospedes} Hóspedes"),
                          _buildInfoRow(Icons.confirmation_number_rounded, "ID: ...${reserva.id.substring(reserva.id.length - 4)}"),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // === PAGAMENTO ===
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Valor Total", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          const SizedBox(height: 4),
                          Text(
                            _formatarMoeda(valorTotal),
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _primaryColor),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: _primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Text("Pago", style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // === BOTÃO CANCELAR ===
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CancelarReserva(
                            reservaID: reserva.id,
                            reservaService: widget.reservaService,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[400],
                      side: BorderSide(color: Colors.red.shade200, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("Cancelar Reserva", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {}, // Lógica de ajuda
                  child: Text("Precisa de ajuda?", style: TextStyle(color: Colors.grey[600])),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // === WIDGETS AUXILIARES ===

  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(date, style: TextStyle(fontSize: 16, color: _textColor, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _primaryColor),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 14, color: _textColor, fontWeight: FontWeight.w500)),
      ],
    );
  }
}