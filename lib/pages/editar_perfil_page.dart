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

  // Cores do tema (para manter consistência)
  final Color _primaryColor = const Color(0xFF192C50);

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.perfilAtual.nome);
    _sobrenomeController = TextEditingController(text: widget.perfilAtual.sobrenome);
    _cpfController = TextEditingController(text: widget.perfilAtual.cpf);
    _telefoneController = TextEditingController(text: widget.perfilAtual.telefone);
    _nascimentoController = TextEditingController(text: widget.perfilAtual.dataNascimento);
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
    // Tenta ler a data atual do campo para iniciar o calendário nela
    DateTime dataInicial = DateTime.now();
    try {
      if (_nascimentoController.text.isNotEmpty) {
        final parts = _nascimentoController.text.split('/');
        if (parts.length == 3) {
          dataInicial = DateTime(
            int.parse(parts[2]), // Ano
            int.parse(parts[1]), // Mês
            int.parse(parts[0]), // Dia
          );
        }
      }
    } catch (e) {
      // Se falhar a conversão, usa a data de hoje
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: DateTime(1900), // Data mínima permitida
      lastDate: DateTime.now(),  // Não permite datas futuras
      locale: const Locale('pt', 'BR'), // Se tiver configurado localizações
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor, // Cor do cabeçalho e seleção
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
        // Formata para dd/mm/aaaa manualmente para não depender de pacotes extras
        String dia = picked.day.toString().padLeft(2, '0');
        String mes = picked.month.toString().padLeft(2, '0');
        String ano = picked.year.toString();
        _nascimentoController.text = "$dia/$mes/$ano";
      });
    }
  }

  void _salvarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final uid = FirebaseAuth.instance.currentUser!.uid;

      Map<String, dynamic> dadosAtualizados = {
        'nome': _nomeController.text.trim(),
        'sobrenome': _sobrenomeController.text.trim(),
        'cpf': _cpfController.text.trim(),
        'telefone': _telefoneController.text.trim(),
        'dataNascimento': _nascimentoController.text.trim(),
      };

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
                _buildTextField("CPF", _cpfController, keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                _buildTextField("Telefone", _telefoneController, keyboardType: TextInputType.phone),
                const SizedBox(height: 20),
                
                // === CAMPO DATA DE NASCIMENTO (Com DatePicker) ===
                _buildTextField(
                  "Data de Nascimento", 
                  _nascimentoController, 
                  readOnly: true, // Bloqueia digitação
                  onTap: () => _selecionarData(context), // Abre calendário
                  suffixIcon: Icons.calendar_today_rounded, // Ícone visual
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === WIDGET DE INPUT ATUALIZADO ===
  Widget _buildTextField(
    String label, 
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false, // Parâmetro novo
    VoidCallback? onTap,   // Parâmetro novo
    IconData? suffixIcon,  // Parâmetro novo
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly, // Usa o parâmetro
          onTap: onTap,       // Usa o parâmetro
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDDDDD))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDDDDD))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF192C50))),
            filled: true,
            fillColor: Colors.grey[50],
            // Ícone opcional na direita (ex: calendário)
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
          ),
          validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
        ),
      ],
    );
  }
}