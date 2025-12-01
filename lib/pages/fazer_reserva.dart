import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_app/data/reserva_service.dart';
import 'package:hotel_app/models/hospede.dart';
import 'package:hotel_app/models/quarto.dart';
import 'package:hotel_app/models/reserva.dart';
import 'package:hotel_app/servicos/auth_service.dart'; // Seu AuthService
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
  final Color _primaryColor = const Color(0xFF0B2A4A);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  
  DateTime _dataEntrada = DateTime.now();
  DateTime _dataSaida = DateTime.now().add(const Duration(days: 1));
  int _quantidadeHospedes = 1;
  
  // Controllers para preencher dados FALTANTES
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  // Variáveis de Dados do Usuário (Vindos do Firestore)
  bool _loadingUserData = true;
  String? _nomeCompletoReal; // Nome + Sobrenome
  String? _cpfSalvo;         // Se vier do banco, guardamos aqui
  String? _telefoneSalvo;    // Se vier do banco, guardamos aqui

  final AuthService _authService = AuthService();

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
    _carregarDadosDoUsuario();
  }

  // ===========================================================================
  // LÓGICA INTELIGENTE: Carrega dados do Firestore
  // ===========================================================================
  Future<void> _carregarDadosDoUsuario() async {
    setState(() => _loadingUserData = true);
    
    // Usa o método getUserData que já existe no seu AuthService
    Map<String, dynamic>? dados = await _authService.getUserData();
    
    if (dados != null && mounted) {
      setState(() {
        // 1. Monta o nome real
        String nome = dados['nome'] ?? '';
        String sobrenome = dados['sobrenome'] ?? '';
        _nomeCompletoReal = "$nome $sobrenome".trim();

        // 2. Verifica se tem CPF e Telefone salvos
        // Se o campo existir e não for vazio, guardamos na variável "_salvo"
        if (dados['cpf'] != null && dados['cpf'].toString().isNotEmpty) {
          _cpfSalvo = dados['cpf'];
        }
        
        if (dados['telefone'] != null && dados['telefone'].toString().isNotEmpty) {
          _telefoneSalvo = dados['telefone'];
        }
        
        _loadingUserData = false;
      });
    } else {
      // Se não achou dados (usuário novo ou erro), libera a tela para digitar tudo
      if (mounted) setState(() => _loadingUserData = false);
    }
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  String _formatarData(DateTime data) => '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  String _formatarMoeda(double valor) => 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';

  Future<void> _buscarDisponibilidade() async {
    try { await widget.reservaService.buscarQuartosDisponiveis(_dataEntrada, _dataSaida); } catch (_) {}
  }

  Future<void> _selecionarData(BuildContext context, bool isEntrada) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: isEntrada ? _dataEntrada : _dataSaida,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: _primaryColor, onPrimary: Colors.white, onSurface: Colors.black)), child: child!);
      },
    );
    if (dataSelecionada != null) {
      setState(() {
        if (isEntrada) {
          _dataEntrada = dataSelecionada;
          if (_dataSaida.isBefore(_dataEntrada) || _dataSaida.isAtSameMomentAs(_dataEntrada)) {
            _dataSaida = _dataEntrada.add(const Duration(days: 1));
          }
        } else {
          if (dataSelecionada.isAfter(_dataEntrada)) _dataSaida = dataSelecionada;
          else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saída deve ser após a entrada.')));
        }
      });
    }
  }

  // ===========================================================================
  // AÇÃO DE RESERVAR
  // ===========================================================================
  Future<void> _fazerReserva(BuildContext context) async {
    // Só valida formulário se houver campos visíveis para digitar
    bool precisaValidar = (_cpfSalvo == null) || (_telefoneSalvo == null);
    
    if (precisaValidar && !_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      // 1. Define os dados finais (Prioridade: Banco > Input)
      String cpfFinal = _cpfSalvo ?? _cpfController.text;
      String telefoneFinal = _telefoneSalvo ?? _telefoneController.text;
      
      // Nome: Se não veio do banco, tenta do Auth, senão usa padrão
      String nomeFinal = _nomeCompletoReal ?? user.displayName ?? "Hóspede App";

      // 2. Cria objeto Hospede
      final hospede = Hospede(
        uidFirebase: user.uid,
        nome: nomeFinal,
        email: user.email ?? '',
        cpf: cpfFinal,
        telefone: telefoneFinal,
      );

      // 3. Cria objeto Reserva
      final novaReserva = Reserva(
        id: '', 
        quartoId: widget.quarto.id,
        clienteId: '', 
        dataEntrada: _dataEntrada,
        dataSaida: _dataSaida,
        valorTotal: _valorTotal,
        status: 'Pendente',
        numHospedes: _quantidadeHospedes,
      );

      // 4. Envia
      final reservaId = await widget.reservaService.criarNovaReserva(novaReserva, hospede);

      // 5. Se o usuário digitou dados novos, poderíamos atualizar o Firestore aqui 
      // para não pedir na próxima vez (Opcional, mas recomendado)
      if (_cpfSalvo == null || _telefoneSalvo == null) {
        await _authService.atualizarDadosUsuario(
          uid: user.uid,
          dados: {
            'cpf': cpfFinal,
            'telefone': telefoneFinal,
          }
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reserva criada! ID: $reservaId')));
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmacaoReserva(reservaID: reservaId, reservaService: widget.reservaService),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Confirmar Reserva', style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)), onPressed: () => Navigator.pop(context)),
      ),
      body: _loadingUserData
          ? Center(child: CircularProgressIndicator(color: _primaryColor))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Quarto: ${widget.quarto.tipo}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _primaryColor)),
                      Text('Preço Diária: ${_formatarMoeda(_precoDiaria)}', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      const SizedBox(height: 30),

                      // === SEÇÃO DE DADOS DO HÓSPEDE (DINÂMICA) ===
                      const Text("Dados do Hóspede", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),

                      // Nome (Sempre Apenas Leitura, vindo do cadastro)
                      _buildInfoCard(Icons.person, "Nome", _nomeCompletoReal ?? "Hóspede"),
                      const SizedBox(height: 15),

                      // CPF: Mostra Card (Confirmado) OU Campo de Texto (Faltando)
                      if (_cpfSalvo != null && _cpfSalvo!.isNotEmpty)
                        _buildInfoCard(Icons.badge, "CPF Confirmado", _cpfSalvo!)
                      else
                        _buildTextField(
                          label: "CPF (apenas números)",
                          controller: _cpfController,
                          icon: Icons.badge_outlined,
                          keyboardType: TextInputType.number,
                        ),

                      const SizedBox(height: 15),

                      // TELEFONE: Mostra Card (Confirmado) OU Campo de Texto (Faltando)
                      if (_telefoneSalvo != null && _telefoneSalvo!.isNotEmpty)
                        _buildInfoCard(Icons.phone, "Telefone Confirmado", _telefoneSalvo!)
                      else
                        _buildTextField(
                          label: "Telefone",
                          controller: _telefoneController,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),

                      const SizedBox(height: 30),
                      // ===============================================

                      _buildDataSelector(context, label: 'Check-in (Entrada)', data: _dataEntrada, isEntrada: true, icon: Icons.login_rounded),
                      const SizedBox(height: 16),
                      _buildDataSelector(context, label: 'Check-out (Saída)', data: _dataSaida, isEntrada: false, icon: Icons.logout_rounded),
                      const SizedBox(height: 25),
                      _buildHospedesSelector(),
                      const SizedBox(height: 40),

                      const Text('Resumo da Estadia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                      const Divider(height: 20, thickness: 1),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Período:', style: TextStyle(fontSize: 16, color: Colors.grey[700])), Text('$_numDiarias Diária(s)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))]),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Hóspedes:', style: TextStyle(fontSize: 16, color: Colors.grey[700])), Text('$_quantidadeHospedes Pessoas', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))]),
                      const SizedBox(height: 10),
                      const Divider(height: 20, thickness: 1.5),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('VALOR TOTAL:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text('${_formatarMoeda(_valorTotal)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor))]),
                      const SizedBox(height: 40),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () => _fazerReserva(context),
                          style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirmar Reserva', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
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

  // Widget para mostrar dados já confirmados (não editáveis)
  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.5)), // Borda verde suave
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2))
        ]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, required IconData icon, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (label.contains("CPF") && value.length < 11) return 'CPF inválido';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildHospedesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quantidade de Hóspedes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_quantidadeHospedes Pessoas', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Row(children: [_RoundIconButton(icon: Icons.remove, color: Colors.grey[700]!, onTap: () { if (_quantidadeHospedes > 1) setState(() => _quantidadeHospedes--); }), const SizedBox(width: 15), _RoundIconButton(icon: Icons.add, color: _primaryColor, onTap: () { if (_quantidadeHospedes < widget.quarto.capacidade) setState(() => _quantidadeHospedes++); else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Limite máximo de hóspedes atingido.'))); })]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataSelector(BuildContext context, {required String label, required DateTime data, required bool isEntrada, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _selecionarData(context, isEntrada),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(icon, size: 20, color: _primaryColor), const SizedBox(width: 10), Text(_formatarData(data), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))]), const Icon(Icons.calendar_today, size: 20, color: Colors.grey)]),
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  const _RoundIconButton({required this.icon, required this.onTap, required this.color});
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(25), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, size: 20, color: color)));
  }
}