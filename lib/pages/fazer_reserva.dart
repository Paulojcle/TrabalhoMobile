import 'package:flutter/material.dart';
import 'package:hotel_app/data/reserva_service.dart';
import 'package:hotel_app/models/quarto.dart';
import 'package:hotel_app/models/reserva.dart';
import 'confirmation_reserva.dart';
import '../data/reserva_service.dart';
import '../models/reserva.dart';

class FazerReservaPage extends StatefulWidget {
  // ⬅️ INJEÇÃO DE DEPENDÊNCIA: O serviço e o quarto são recebidos
  final ReservaService reservaService;
  final Quarto quarto;

  const FazerReservaPage({
    super.key,
    required this.reservaService,
    required this.quarto,
  });

  @override
  State<FazerReservaPage> createState() => _FazerReservaPageState();
}

class _FazerReservaPageState extends State<FazerReservaPage> {
  // ⬅️ Variáveis de Estado
  DateTime _dataEntrada = DateTime.now();
  DateTime _dataSaida = DateTime.now().add(const Duration(days: 1));
  int _quantidadeHospedes = 1; // ⬅️ NOVO ESTADO: Quantidade de hóspedes
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ⬅️ Cálculos derivados
  double get _precoDiaria => widget.quarto.preco;

  int get _numDiarias {
    if (_dataSaida.isAfter(_dataEntrada)) {
      return _dataSaida.difference(_dataEntrada).inDays;
    }
    return 1;
  }

  double get _valorTotal => _precoDiaria * _numDiarias;

  @override
  void initState() {
    super.initState();
    _buscarDisponibilidade();
    // Garante que o número inicial de hóspedes não excede a capacidade do quarto
    _quantidadeHospedes = 1;
  }

  // Função auxiliar para formatação manual de data (removendo a necessidade do 'intl')
  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  // Função auxiliar para formatação manual de moeda
  String _formatarMoeda(double valor) {
    String valorString = valor.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $valorString';
  }

  // 1. Lógica para buscar disponibilidade (chama a API)
  Future<void> _buscarDisponibilidade() async {
    // ⚠️ Nota: O setState() para atualizar o _valorTotal já é chamado em _selecionarData
    try {
      // ⬅️ Chama o método que irá bater na API
      await widget.reservaService.buscarQuartosDisponiveis(
        _dataEntrada,
        _dataSaida,
      );
      print("Verificação de disponibilidade enviada para a API.");
    } catch (e) {
      print("Erro ao buscar disponibilidade: $e");
      // TODO: Mostrar mensagem de erro para o usuário
    }
  }

  // Função para abrir o seletor de datas e atualizar o estado
  Future<void> _selecionarData(BuildContext context, bool isEntrada) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: isEntrada ? _dataEntrada : _dataSaida,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (dataSelecionada != null) {
      setState(() {
        if (isEntrada) {
          _dataEntrada = dataSelecionada;
          if (_dataSaida.isBefore(_dataEntrada) ||
              _dataSaida.isAtSameMomentAs(_dataEntrada)) {
            _dataSaida = _dataEntrada.add(const Duration(days: 1));
          }
        } else {
          if (dataSelecionada.isAfter(_dataEntrada)) {
            _dataSaida = dataSelecionada;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'A data de saída deve ser depois da data de entrada.',
                ),
              ),
            );
          }
        }
        _buscarDisponibilidade(); // Chama o check de API e, implicitamente, o valor total é recalculado.
      });
    }
  }

  // 2. Lógica para criar a reserva (chama a API)
  Future<void> _fazerReserva(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_quantidadeHospedes > widget.quarto.capacidade) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Número de hóspedes excede a capacidade do quarto (${widget.quarto.capacidade}).',
          ),
        ),
      );
      return;
    }

    try {
      // Cria o objeto Reserva para ser serializado (toJson) e enviado
      final novaReserva = Reserva(
        id: 'temp_id_local', // ID temporário, será substituído pela API
        quartoId: widget.quarto.id,
        clienteId: 'CLIENTE_LOGADO_ID', // Substituir pelo ID do usuário real
        dataEntrada: _dataEntrada,
        dataSaida: _dataSaida,
        valorTotal: _valorTotal,
        status: 'PENDING',
        numHospedes: _quantidadeHospedes,
      );

      // Chama o serviço da API para criar a reserva
      final reservaId = await widget.reservaService.criarNovaReserva(
        novaReserva,
      );

      // Navega para a tela de confirmação (você deve criar esta tela)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmacaoReserva(
            reservaID: reservaId,
            reservaService: widget.reservaService,
          ),
        ),
      );

      // Exemplo de sucesso:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserva criada com sucesso! ID: $reservaId')),
      );
    } catch (e) {
      print("Erro ao processar reserva: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao criar reserva. Tente novamente.'),
        ),
      );
    }
  }

  // --- Build (UI) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar ${widget.quarto.tipo}'),
      ), // Usando nome do quarto
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Detalhes do Quarto
              Text(
                'Preço Diária: ${_formatarMoeda(_precoDiaria)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Seletor de Data de Entrada
              _buildDataSelector(
                context,
                label: 'Check-in (Entrada)',
                data: _dataEntrada,
                isEntrada: true,
              ),
              const SizedBox(height: 16),

              // Seletor de Data de Saída
              _buildDataSelector(
                context,
                label: 'Check-out (Saída)',
                data: _dataSaida,
                isEntrada: false,
              ),
              const SizedBox(height: 16),

              // ⬅️ NOVO: Seletor de Quantidade de Hóspedes
              _buildHospedesSelector(),
              const SizedBox(height: 30),

              // Resumo da Reserva
              const Text(
                'Resumo da Estadia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Diárias:',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  Text('$_numDiarias', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hóspedes:',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  Text(
                    '$_quantidadeHospedes',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Valor Total:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_formatarMoeda(_valorTotal)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Botão de Reserva
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _fazerReserva(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF192C50),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Confirmar Reserva',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHospedesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantidade de Hóspedes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_quantidadeHospedes Pessoas',
                style: const TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (_quantidadeHospedes > 1) {
                        setState(() {
                          _quantidadeHospedes--;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  _RoundIconButton(
                    icon: Icons.add,
                    onTap: () {
                      if (_quantidadeHospedes < widget.quarto.capacidade) {
                        setState(() {
                          _quantidadeHospedes++;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Limite máximo de hóspedes (${widget.quarto.capacidade}) atingido para este quarto.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          'Capacidade máxima do quarto: ${widget.quarto.capacidade} Pessoas.',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildDataSelector(
    BuildContext context, {
    required String label,
    required DateTime data,
    required bool isEntrada,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selecionarData(context, isEntrada),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatarData(data), style: const TextStyle(fontSize: 16)),
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Widget auxiliar para os botões de + e -
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.blueAccent),
      ),
    );
  }
}
