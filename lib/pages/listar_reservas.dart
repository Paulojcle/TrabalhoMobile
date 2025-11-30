// lib/pages/listar_reservas.dart

import 'package:flutter/material.dart';
import 'package:hotel_app/data/reserva_service.dart';
import 'package:hotel_app/models/reserva.dart';
import 'detalhes_reserva.dart';

class ListarReservasPage extends StatefulWidget {
  final ReservaService reservaService;

  const ListarReservasPage({super.key, required this.reservaService});

  @override
  State<ListarReservasPage> createState() => _ListarReservasPageState();
}

class _ListarReservasPageState extends State<ListarReservasPage> {
  // ⚠️ NÃO inicialize o Future aqui
  late Future<List<Reserva>> _futureReservas;
  final String _clienteId = 'ID_DO_CLIENTE_MOCK';
  final Color primaryColor = const Color(0xFF192C50);

  // Remova o @override void initState() completo.
  // Se ele estava vazio, apenas o ignore.

  // ⬅️ NOVO MÉTODO PARA GARANTIR RECARGA
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reatribui o Future sempre que as dependências mudam ou o widget é re-exibido
    _futureReservas = widget.reservaService.buscarMinhasReservas(_clienteId);
  }

  // Função auxiliar
  String _formatarData(DateTime data) =>
      '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

  // Método para recarregar manualmente
  void _recarregarLista() {
    setState(() {
      _futureReservas = widget.reservaService.buscarMinhasReservas(_clienteId);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: _recarregarLista, // ⬅️ Usa o método de recarga
              ),
            ],
          ),
        ),

        Expanded(
          child: FutureBuilder<List<Reserva>>(
            future: _futureReservas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }
              // ... (código para hasError e lista vazia)
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Erro ao carregar reservas. Erro: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
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

                  return ListTile(
                    title: Text('Quarto ID: ${reserva.quartoId}'),
                    subtitle: Text(
                      'Check-in: ${_formatarData(reserva.dataEntrada)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      // ⬅️ USA await: espera o retorno da tela de Detalhes
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalhesReservaPage(
                            reservaID: reserva.id,
                            reservaService: widget.reservaService,
                          ),
                        ),
                      );
                      // Ao retornar, forçamos a recarga
                      _recarregarLista();
                    },
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
