import 'package:flutter/material.dart';
import 'package:hotel_app/models/reserva.dart';
import 'package:hotel_app/models/quarto.dart';
import '../data/reserva_service.dart';
import 'cancelar_reserva.dart';
import '../models/reserva.dart';

// Importe a ListarReservasPage se for necessária navegação explícita
// import 'listar_reservas.dart';

class DetalhesReservaPage extends StatefulWidget {
  // ⬅️ RECEBENDO ID E SERVIÇO
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
  // Future que carrega tanto a Reserva quanto o Quarto
  late Future<(Reserva, Quarto)> _futureDetalhes;
  final Color primaryColor = const Color(0xFF192C50);
  final Color accentColor = Colors.orange.shade700; // Cor de destaque

  @override
  void initState() {
    super.initState();
    // ⬅️ RESTAURADA A BUSCA DE DADOS
    _futureDetalhes = _carregarDetalhes();
  }

  // Função que busca a Reserva e o Quarto em sequência
  Future<(Reserva, Quarto)> _carregarDetalhes() async {
    final reserva = await widget.reservaService.buscarReservaPorId(
      widget.reservaID,
    );

    final quartos = await widget.reservaService.buscarTodosQuartos();

    final quarto = quartos.firstWhere(
      (q) => q.id == reserva.quartoId,
      orElse: () => throw Exception('Quarto não encontrado para esta reserva.'),
    );

    return (reserva, quarto);
  }

  // Funções Auxiliares
  String _formatarData(DateTime data) =>
      '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

  String _formatarMoeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  double _calcularValorTotal(Reserva reserva, Quarto quarto) {
    final numDiarias = reserva.dataSaida.difference(reserva.dataEntrada).inDays;
    return quarto.preco * (numDiarias > 0 ? numDiarias : 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Reserva'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Ir para Lista de Reservas',
            onPressed: () {
              // Volta para a página anterior (ListarReservasPage)
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: FutureBuilder<(Reserva, Quarto)>(
        future: _futureDetalhes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: accentColor));
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  '❌ Erro ao carregar: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          // ⬅️ UTILIZANDO DADOS DINÂMICOS NA ESTÉTICA MODERNA
          final (reserva, quarto) = snapshot.data!;
          final valorTotal = _calcularValorTotal(reserva, quarto);

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              // --- Secção 1: Cabeçalho da Reserva (Destaque) ---
              _CabecalhoReserva(
                titulo: quarto.tipo ?? quarto.tipo, // Nome do Quarto
                reservaID: reserva.id,
                primaryColor: primaryColor,
              ),

              const SizedBox(height: 20),

              // --- Secção 2: CARD ÚNICO (Detalhes, Datas e Localização) ---
              _DetalhesCardConsolidado(
                primaryColor: primaryColor,
                dataEntrada: _formatarData(reserva.dataEntrada),
                dataSaida: _formatarData(reserva.dataSaida),
                localizacao: quarto.descricao, // Descrição/Local do quarto
                numHospedes: reserva.numHospedes,
              ),

              const SizedBox(height: 20),

              // --- Secção 3: Valor Total em Destaque ---
              _ValorTotalCard(
                valorTotal: _formatarMoeda(valorTotal),
                primaryColor: primaryColor,
                accentColor: accentColor,
              ),

              const SizedBox(height: 40),

              // --- Secção 4: Botão de Ação ---
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  label: const Text(
                    "CANCELAR RESERVA",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ------------------------------------------
// --- Widgets de Apoio (Estética) ---
// ------------------------------------------

class _CabecalhoReserva extends StatelessWidget {
  final String titulo;
  final String reservaID;
  final Color primaryColor;

  const _CabecalhoReserva({
    required this.titulo,
    required this.reservaID,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: primaryColor.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "RESERVA CONFIRMADA",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: primaryColor.withOpacity(0.3)),
          Text(
            "ID da Reserva: $reservaID",
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _DetalhesCardConsolidado extends StatelessWidget {
  final Color primaryColor;
  final String dataEntrada;
  final String dataSaida;
  final String localizacao;
  final int numHospedes;

  const _DetalhesCardConsolidado({
    required this.primaryColor,
    required this.dataEntrada,
    required this.dataSaida,
    required this.localizacao,
    required this.numHospedes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detalhes da Estadia",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Divider(),

            _BookingDetailRow(
              icon: Icons.login,
              label: 'Check-in',
              value: dataEntrada,
              color: primaryColor,
            ),
            _BookingDetailRow(
              icon: Icons.logout,
              label: 'Check-out',
              value: dataSaida,
              color: primaryColor,
            ),
            _BookingDetailRow(
              icon: Icons.location_on,
              label: 'Localização',
              value: localizacao,
              color: primaryColor,
            ),
            _BookingDetailRow(
              icon: Icons.people,
              label: 'Número de Hóspedes',
              value: numHospedes.toString(),
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _ValorTotalCard extends StatelessWidget {
  final String valorTotal;
  final Color primaryColor;
  final Color accentColor;

  const _ValorTotalCard({
    required this.valorTotal,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "VALOR TOTAL",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              valorTotal,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: accentColor,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _BookingDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
