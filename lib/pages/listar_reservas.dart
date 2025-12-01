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
  Future<List<Reserva>>? _futureReservas; // Pode ser nulo se não estiver logado
  final Color primaryColor = const Color(0xFF192C50);
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _verificarUsuario();
  }

  // 2. Método para pegar o usuário real
  void _verificarUsuario() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
      if (user != null) {
        // Usa o UID real do Firebase
        _futureReservas = widget.reservaService.buscarMinhasReservas(user.uid);
      } else {
        _futureReservas = null;
      }
    });
  }

  String _formatarData(DateTime data) =>
      '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

  // Método para recarregar manualmente
  void _recarregarLista() {
    _verificarUsuario(); // Re-checa o usuário e busca novamente
  }

  @override
  Widget build(BuildContext context) {
    // 3. Verifica se o usuário está logado antes de montar a tela
    if (_currentUser == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 60, color: Colors.grey),
            const SizedBox(height: 20),
            const Text("Faça login para ver suas reservas"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await requireLogin(context); // Chama a tela de login
                _recarregarLista(); // Tenta carregar ao voltar
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text("Fazer Login", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      );
    }

    // Se estiver logado, mostra a lista
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho com o botão de Refresh
        Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Minhas Reservas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF192C50),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 30),
                color: primaryColor,
                onPressed: _recarregarLista,
              ),
            ],
          ),
        ),

        Expanded(
          child: FutureBuilder<List<Reserva>>(
            // Usa o Future que foi configurado com o ID real
            future: _futureReservas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }
              
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 40),
                        const SizedBox(height: 10),
                        Text(
                          'Erro ao carregar reservas.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        TextButton(
                           onPressed: _recarregarLista,
                           child: const Text("Tentar novamente")
                        )
                      ],
                    ),
                  ),
                );
              }

              final reservas = snapshot.data ?? [];

              if (reservas.isEmpty) {
                return const Center(
                  child: Text('Você não tem reservas ativas.'),
                );
              }

              return ListView.builder(
                itemCount: reservas.length,
                itemBuilder: (context, index) {
                  final reserva = reservas[index];

                  // Melhorei levemente o visual para mostrar o Status
                  Color statusColor = Colors.grey;
                  if (reserva.status.toLowerCase() == 'confirmada') statusColor = Colors.green;
                  if (reserva.status.toLowerCase() == 'cancelada') statusColor = Colors.red;

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today, color: primaryColor),
                      title: Text(
                        'Quarto: ${reserva.quartoId}', // Se quiser o nome do quarto, precisaria buscar o objeto Quarto
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Entrada: ${_formatarData(reserva.dataEntrada)}'),
                          Text(
                            'Status: ${reserva.status}',
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
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
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}