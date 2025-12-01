import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../servicos/auth_service.dart';
import 'profile.dart'; 

class EditarPerfilPage extends StatefulWidget {
  final UserProfile perfilAtual;

  const EditarPerfilPage({super.key, required this.perfilAtual});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nomeController;
  late TextEditingController _sobrenomeController;
  late TextEditingController _cpfController;
  late TextEditingController _telefoneController;
  late TextEditingController _nascimentoController;

  bool _isLoading = false;
  
  // ⚠️ NOVO: Variável de controle de imutabilidade do CPF
  bool _isCpfEditable = true; 

  // Cores do tema
  final Color _primaryColor = const Color(0xFF192C50);

  @override
  void initState() {
    super.initState();
    // 1. Inicializa os Controllers
    _nomeController = TextEditingController(text: widget.perfilAtual.nome);
    _sobrenomeController = TextEditingController(text: widget.perfilAtual.sobrenome);
    
    // NOVO: Inicializa vazio se for 'Não informado' para evitar a string no campo
    _cpfController = TextEditingController(text: widget.perfilAtual.cpf != 'Não informado' ? widget.perfilAtual.cpf : '');
    _telefoneController = TextEditingController(text: widget.perfilAtual.telefone != 'Não informado' ? widget.perfilAtual.telefone : '');
    _nascimentoController = TextEditingController(text: widget.perfilAtual.dataNascimento != 'Não informada' ? widget.perfilAtual.dataNascimento : '');
    
    // 2. Regra de Imutabilidade
    if (widget.perfilAtual.cpf != 'Não informado' && widget.perfilAtual.cpf.isNotEmpty) {
      _isCpfEditable = false; // Se já tem CPF, bloqueia a edição
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _nascimentoController.dispose();
    super.dispose();
  }

  // === FUNÇÃO PARA ABRIR O CALENDÁRIO ===
  Future<void> _selecionarData(BuildContext context) async {
    
    DateTime hoje = DateTime.now();
    // Limites de 18 a 120 anos
    final DateTime dataMinimaPermitida = DateTime(hoje.year - 120, hoje.month, hoje.day);
    final DateTime dataMaximaPermitida = DateTime(hoje.year - 18, hoje.month, hoje.day);

    // 1. Tenta definir a data inicial com base no que está no Controller
    DateTime dataInicialDoController = dataMaximaPermitida;

    if (_nascimentoController.text.isNotEmpty) {
      try {
        final parts = _nascimentoController.text.split('/');
        if (parts.length == 3) {
          // Converte dd/mm/yyyy para DateTime
          DateTime parsedDate = DateTime(
            int.parse(parts[2]), // Ano
            int.parse(parts[1]), // Mês
            int.parse(parts[0]), // Dia
          );
          
          // 2. Verifica se a data parseada está dentro dos limites de 120-18 anos
          if (parsedDate.isAfter(dataMinimaPermitida) && parsedDate.isBefore(dataMaximaPermitida)) {
            dataInicialDoController = parsedDate;
          }
        }
      } catch (e) {
        // Se a conversão do texto falhar, usa a data máxima permitida
      }
    }
    
    // 3. Define a data inicial final para o calendário
    // Se o controller estava vazio ou inválido, ele usará a dataMaximaPermitida (18 anos)
    // Se estava válido, ele usará o valor do controller.

    final DateTime? picked = await showDatePicker(
      context: context,
      
      // Usa a data processada do controller como initialDate
      initialDate: dataInicialDoController, 
      
      firstDate: dataMinimaPermitida,
      lastDate: dataMaximaPermitida,
      locale: const Locale('pt', 'BR'),
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

    if (picked != null) {
      setState(() {
        // 4. Salva a data selecionada no formato dd/mm/aaaa
        String dia = picked.day.toString().padLeft(2, '0');
        String mes = picked.month.toString().padLeft(2, '0');
        String ano = picked.year.toString();
        _nascimentoController.text = "$dia/$mes/$ano";
      });
    }
  }

  void _salvarAlteracoes() async {
    // Validação condicional: só valida campos que são editáveis
    if (_isCpfEditable && _cpfController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("O CPF é obrigatório para o cadastro.")));
      return;
    }
    
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final uid = FirebaseAuth.instance.currentUser!.uid;

      Map<String, dynamic> dadosAtualizados = {
        'nome': _nomeController.text.trim(),
        'sobrenome': _sobrenomeController.text.trim(),
        'telefone': _telefoneController.text.trim(),
        'dataNascimento': _nascimentoController.text.trim(),
      };
      
      // ⚠️ CRÍTICO: Só adiciona o CPF ao payload se ele for editável (ou seja, se estiver sendo preenchido pela 1ª vez)
      if (_isCpfEditable) {
        dadosAtualizados['cpf'] = _cpfController.text.trim();
      }
      
      String? erro = await AuthService().atualizarDadosUsuario(
        uid: uid,
        dados: dadosAtualizados,
      );

      setState(() => _isLoading = false);

      if (erro == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Perfil atualizado com sucesso!")));
        Navigator.pop(context, true); 
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $erro")));
      }
    }
  }

  // === WIDGET DE INPUT ATUALIZADO ===
  Widget _buildTextField(
    String label, 
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
    int? maxLength,
    // NOVO: Indica se é o CPF para aplicar validação extra
    bool isCpf = false, 
  }) {
    // Estilo para campo bloqueado
    Color fillColor = readOnly ? Colors.grey[100]! : Colors.grey[50]!;
    Color borderColor = readOnly ? Colors.grey[300]! : const Color(0xFFDDDDDD);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          maxLength: maxLength,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF192C50))),
            filled: true,
            fillColor: fillColor, // Cor diferente se for readOnly
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
            counterText: maxLength != null ? "" : null,
          ),
          validator: (value) {
            // Se for readOnly, a validação é desnecessária
            if (readOnly) return null;

            if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
            }
            
            // Validação de CPF para campos editáveis
            if (isCpf && value.length != 11) {
                return 'CPF deve ter 11 dígitos';
            }
            return null;
          },
          // Se o campo for ReadOnly, a cor do texto também fica mais suave para UX
          style: TextStyle(color: readOnly ? Colors.grey[600] : Colors.black87),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Editar Perfil", style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF333333)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _salvarAlteracoes,
            child: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
              : const Text("Salvar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField("Nome", _nomeController),
                const SizedBox(height: 20),
                _buildTextField("Sobrenome", _sobrenomeController),
                const SizedBox(height: 20),
                
                // 🛑 CPF COM REGRA DE IMUTABILIDADE 🛑
                _buildTextField(
                  "CPF", 
                  _cpfController, 
                  keyboardType: TextInputType.number, 
                  maxLength: 11,
                  isCpf: true, // Indica que este é o campo CPF
                  readOnly: !_isCpfEditable, // APLICA A REGRA AQUI
                ),
                
                const SizedBox(height: 20),
                
                _buildTextField("Telefone", _telefoneController, keyboardType: TextInputType.phone, maxLength: 15),
                
                const SizedBox(height: 20),
                
                // Data de Nascimento
                _buildTextField(
                  "Data de Nascimento", 
                  _nascimentoController, 
                  readOnly: true,
                  onTap: () => _selecionarData(context),
                  suffixIcon: Icons.calendar_today_rounded,
                  maxLength: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}