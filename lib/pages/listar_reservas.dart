import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_app/data/reserva_service.dart';
import 'package:hotel_app/models/reserva.dart';
import 'package:hotel_app/servicos/auth_guard.dart';
import 'detalhes_reserva.dart';

class ListarReservasPage extends StatefulWidget {
  final ReservaService reservaService;

  const ListarReservasPage({super.key, required this.reservaService});

  @override
  State<ListarReservasPage> createState() => _ListarReservasPageState();
}

class _ListarReservasPageState extends State<ListarReservasPage> {
  Future<List<Reserva>>? _futureReservas;
  User? _currentUser;

  // Paleta de Cores (Consistente com o App)
  final Color _primaryColor = const Color(0xFF0B2A4A);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _verificarUsuario();
  }

  void _verificarUsuario() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
      if (user != null) {
        _futureReservas = widget.reservaService.buscarMinhasReservas(user.uid);
      } else {
        _futureReservas = null;
      }
    });
  }

  void _recarregarLista() {
    _verificarUsuario();
  }

  // Formatadores
  String _formatarData(DateTime data) =>
      '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

  String _formatarMoeda(double valor) =>
      'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // === CABEÇALHO PERSONALIZADO ===
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Minhas Reservas',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        'Histórico e agendamentos',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.refresh_rounded, color: _primaryColor),
                      onPressed: _recarregarLista,
                    ),
                  ),
                ],
              ),
            ),

            // === CONTEÚDO PRINCIPAL ===
            Expanded(
              child: _currentUser == null
                  ? _buildLoginRequiredState()
                  : _buildReservasList(),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Estado: Login Necessário
  Widget _buildLoginRequiredState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_person_rounded, size: 60, color: _primaryColor),
            ),
            const SizedBox(height: 25),
            const Text(
              "Acesso Restrito",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Faça login para gerenciar suas estadias e ver seu histórico.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await requireLogin(context);
                  _recarregarLista();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Fazer Login / Criar Conta",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 2. Estado: Lista de Reservas (Com FutureBuilder)
  Widget _buildReservasList() {
    return FutureBuilder<List<Reserva>>(
      future: _futureReservas,
      builder: (context, snapshot) {
        // Carregando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: _primaryColor));
        }

        // Erro
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 20),
                  Text(
                    "Não foi possível carregar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: _recarregarLista,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Tentar Novamente"),
                  )
                ],
              ),
            ),
          );
        }

        final reservas = snapshot.data ?? [];

        // Lista Vazia
        if (reservas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 20),
                Text(
                  "Nenhuma reserva encontrada",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
                const SizedBox(height: 5),
                Text(
                  "Suas futuras viagens aparecerão aqui.",
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        // Lista Sucesso
        return RefreshIndicator(
          onRefresh: () async => _recarregarLista(),
          color: _primaryColor,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: reservas.length,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final reserva = reservas[index];
              return _buildReservaCard(reserva);
            },
          ),
        );
      },
    );
  }

  // 3. O Card da Reserva (Bonito)
  Widget _buildReservaCard(Reserva reserva) {
    // Lógica de cores baseada no status
    Color statusColor;
    Color statusBg;
    String statusText = reserva.status.toUpperCase();

    switch (reserva.status.toLowerCase()) {
      case 'confirmada':
        statusColor = Colors.green.shade700;
        statusBg = Colors.green.shade50;
        break;
      case 'cancelada':
        statusColor = Colors.red.shade700;
        statusBg = Colors.red.shade50;
        break;
      case 'finalizada':
        statusColor = Colors.grey.shade700;
        statusBg = Colors.grey.shade100;
        break;
      default: // Pendente
        statusColor = Colors.orange.shade800;
        statusBg = Colors.orange.shade50;
        statusText = "PENDENTE"; // Tradução visual se necessário
    }

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalhesReservaPage(
              reservaID: reserva.id,
              reservaService: widget.reservaService,
            ),
          ),
        );
        _recarregarLista();
      },
      child: Container(
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha Superior: ID do Quarto e Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.bed_rounded, color: _primaryColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Quarto",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "#${reserva.quartoId}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Chip de Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 15),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 15),

              // Linha do Meio: Datas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn("Check-in", _formatarData(reserva.dataEntrada), CrossAxisAlignment.start),
                  Icon(Icons.arrow_right_alt_rounded, color: Colors.grey[300]),
                  _buildInfoColumn("Check-out", _formatarData(reserva.dataSaida), CrossAxisAlignment.end),
                ],
              ),

              const SizedBox(height: 15),
              
              // Linha Inferior: Valor e Hóspedes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        "${reserva.numHospedes} Hóspedes",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  Text(
                    _formatarMoeda(reserva.valorTotal),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _primaryColor,
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

  Widget _buildInfoColumn(String label, String value, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
        ),
      ],
    );
  }
}