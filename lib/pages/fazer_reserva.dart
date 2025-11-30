import 'package:flutter/material.dart';
import 'package:hotel_app/data/reserva_service.dart';
import 'package:hotel_app/models/quarto.dart';
import 'package:hotel_app/models/reserva.dart';
import 'confirmation_reserva.dart';

class FazerReservaPage extends StatefulWidget {
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
  // Cores do Tema
  final Color _primaryColor = const Color(0xFF0B2A4A);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  
  DateTime _dataEntrada = DateTime.now();
  DateTime _dataSaida = DateTime.now().add(const Duration(days: 1));
  int _quantidadeHospedes = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    _quantidadeHospedes = 1;
  }

  // Função auxiliar para formatação manual de data
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

  // 1. Lógica para buscar disponibilidade
  Future<void> _buscarDisponibilidade() async {
    try {
      await widget.reservaService.buscarQuartosDisponiveis(
        _dataEntrada,
        _dataSaida,
      );
    } catch (e) {
      // Mostrar mensagem de erro para o usuário
    }
  }

  // Função para abrir o seletor de datas e atualizar o estado
  Future<void> _selecionarData(BuildContext context, bool isEntrada) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: isEntrada ? _dataEntrada : _dataSaida,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      // Aplica o tema do app ao calendário
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor, 
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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
                content: Text('A data de saída deve ser depois da data de entrada.'),
              ),
            );
          }
        }
        _buscarDisponibilidade();
      });
    }
  }

  // 2. Lógica para criar a reserva
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
      final novaReserva = Reserva(
        id: 'temp_id_local',
        quartoId: widget.quarto.id,
        clienteId: 'CLIENTE_LOGADO_ID',
        dataEntrada: _dataEntrada,
        dataSaida: _dataSaida,
        valorTotal: _valorTotal,
        status: 'PENDING',
        numHospedes: _quantidadeHospedes,
      );

      final reservaId = await widget.reservaService.criarNovaReserva(
        novaReserva,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserva criada com sucesso! ID: $reservaId')),
      );
      
      // Navega para a tela de confirmação
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmacaoReserva(
            reservaID: reservaId,
            reservaService: widget.reservaService,
          ),
        ),
      );

    } catch (e) {
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
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Confirmar Reserva',
          style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                // HEADER INFO
                Text(
                  'Quarto: ${widget.quarto.tipo}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _primaryColor,
                  ),
                ),
                Text(
                  'Preço Diária: ${_formatarMoeda(_precoDiaria)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),

                // Seletor de Data de Entrada
                _buildDataSelector(
                  context,
                  label: 'Check-in (Entrada)',
                  data: _dataEntrada,
                  isEntrada: true,
                  icon: Icons.login_rounded,
                ),
                const SizedBox(height: 16),

                // Seletor de Data de Saída
                _buildDataSelector(
                  context,
                  label: 'Check-out (Saída)',
                  data: _dataSaida,
                  isEntrada: false,
                  icon: Icons.logout_rounded,
                ),
                const SizedBox(height: 25),

                // Seletor de Quantidade de Hóspedes
                _buildHospedesSelector(),
                const SizedBox(height: 40),

                // Resumo da Reserva
                const Text(
                  'Resumo da Estadia',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                ),
                const Divider(height: 20, thickness: 1),
                
                // Linha Diárias
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Período:', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    Text('$_numDiarias Diária(s)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                
                // Linha Hóspedes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hóspedes:', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    Text(
                      '$_quantidadeHospedes Pessoas',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Linha Total
                const Divider(height: 20, thickness: 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'VALOR TOTAL:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_formatarMoeda(_valorTotal)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor, // Cor Primária
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Botão de Reserva
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => _fazerReserva(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Confirmar Reserva',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === WIDGETS AUXILIARES ===

  Widget _buildHospedesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantidade de Hóspedes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_quantidadeHospedes Pessoas',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.remove,
                    color: Colors.grey[700]!,
                    onTap: () {
                      if (_quantidadeHospedes > 1) setState(() => _quantidadeHospedes--);
                    },
                  ),
                  const SizedBox(width: 15),
                  _RoundIconButton(
                    icon: Icons.add,
                    color: _primaryColor,
                    onTap: () {
                      if (_quantidadeHospedes < widget.quarto.capacidade) {
                        setState(() => _quantidadeHospedes++);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Limite máximo de hóspedes (${widget.quarto.capacidade}) atingido.')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
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
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _selecionarData(context, isEntrada),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: _primaryColor),
                    const SizedBox(width: 10),
                    Text(_formatarData(data), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
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
  final Color color;

  const _RoundIconButton({required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}