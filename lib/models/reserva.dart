// lib/models/reserva.dart

class Reserva {
  final String id;
  final String quartoId;
  final String clienteId; // Isso armazena o CPF do hóspede
  final DateTime dataEntrada;
  final DateTime dataSaida;
  final double valorTotal;
  final String status;
  final int numHospedes;

  const Reserva({
    required this.id,
    required this.quartoId,
    required this.clienteId,
    required this.dataEntrada,
    required this.dataSaida,
    required this.valorTotal,
    required this.status,
    required this.numHospedes,
  });

  // ==========================================================
  // 1. LER DO DJANGO (GET)
  // ==========================================================
  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'].toString(),
      
      // Tenta ler 'quarto' (objeto ou id)
      quartoId: json['quarto'].toString(),
      
      // O Django pode mandar 'hospede' ou 'cliente' dependendo do serializer
      clienteId: (json['hospede'] ?? json['cliente'] ?? '').toString(),
      
      // Mapeia os campos de data que vêm do Django
      dataEntrada: DateTime.parse(json['dtEntrada'] ?? json['checkin'] ?? DateTime.now().toString()),
      dataSaida: DateTime.parse(json['dtSaida'] ?? json['checkout'] ?? DateTime.now().toString()),
      
      valorTotal: double.tryParse(json['valor_total']?.toString() ?? '0') ?? 0.0,
      
      status: json['status'] ?? 'Pendente',
      
      // Mapeia quantidade de pessoas
      numHospedes: int.tryParse((json['quantPessoas'] ?? json['numero_hospedes']).toString()) ?? 1,
    );
  }

  // ==========================================================
  // 2. ENVIAR PARA O DJANGO (POST) 
  // ==========================================================
  Map<String, dynamic> toJson() {
    return {
      // Se tiver ID, envia (edição), senão ignora
      if (id.isNotEmpty) 'id': id,
      
      // CORREÇÃO 1: Campo 'quarto' deve ser Inteiro
      'quarto': int.tryParse(quartoId), 
      
      // CORREÇÃO 2: A chave deve ser 'hospede' (é o CPF/String)
      'hospede': clienteId, 
      
      // CORREÇÃO 3: A chave deve ser 'dtEntrada' (YYYY-MM-DD)
      'dtEntrada': dataEntrada.toIso8601String().split('T')[0],
      
      // CORREÇÃO 4: A chave deve ser 'dtSaida' (YYYY-MM-DD)
      'dtSaida': dataSaida.toIso8601String().split('T')[0],
      
      // CORREÇÃO 5: A chave deve ser 'quantPessoas'
      'quantPessoas': numHospedes,

      // Campos opcionais que talvez seu model use internamente ou ignore
      'valor_total': valorTotal,
      'status': status,
    };
  }

  // ==========================================================
  // 3. COPY WITH
  // ==========================================================
  Reserva copyWith({
    String? id,
    String? quartoId,
    String? clienteId,
    DateTime? dataEntrada,
    DateTime? dataSaida,
    double? valorTotal,
    String? status,
    int? numHospedes,
  }) {
    return Reserva(
      id: id ?? this.id,
      quartoId: quartoId ?? this.quartoId,
      clienteId: clienteId ?? this.clienteId,
      dataEntrada: dataEntrada ?? this.dataEntrada,
      dataSaida: dataSaida ?? this.dataSaida,
      valorTotal: valorTotal ?? this.valorTotal,
      status: status ?? this.status,
      numHospedes: numHospedes ?? this.numHospedes,
    );
  }
}