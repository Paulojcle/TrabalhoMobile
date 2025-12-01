class Reserva {
  final String id;
  final String quartoId;
  final String clienteId;
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
  // 1. ADICIONADO: Converte JSON do Django para Objeto Reserva
  // ==========================================================
  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      // Converte para String, pois o Django pode enviar int
      id: json['id'].toString(),
      
      // Django envia 'quarto' (ID), mapeamos para quartoId
      quartoId: (json['quarto'] ?? json['quartoId']).toString(),
      
      // Django envia 'cliente' (ID), mapeamos para clienteId
      clienteId: (json['cliente'] ?? json['clienteId']).toString(),
      
      // Tenta ler 'checkin' ou 'data_entrada'
      dataEntrada: DateTime.parse(json['checkin'] ?? json['data_entrada']),
      
      // Tenta ler 'checkout' ou 'data_saida'
      dataSaida: DateTime.parse(json['checkout'] ?? json['data_saida']),
      
      valorTotal: double.tryParse(json['valor_total'].toString()) ?? 0.0,
      
      status: json['status'] ?? 'Pendente',
      
      // Se não vier do banco, assume 1
      numHospedes: int.tryParse(json['numero_hospedes'].toString()) ?? 1,
    );
  }

  // ==========================================================
  // 2. ADICIONADO: Converte Objeto Reserva para JSON (Enviar p/ API)
  // ==========================================================
  Map<String, dynamic> toJson() {
    return {
      // Nota: Geralmente não enviamos ID na criação, mas se for edição, enviamos.
      if (id.isNotEmpty) 'id': id,
      
      // Django espera chaves que batam com o serializer dele
      'quarto': int.tryParse(quartoId), 
      'cliente': int.tryParse(clienteId),
      
      // Formata data para YYYY-MM-DD
      'checkin': dataEntrada.toIso8601String().split('T')[0],
      'checkout': dataSaida.toIso8601String().split('T')[0],
      
      'valor_total': valorTotal,
      'status': status,
      'numero_hospedes': numHospedes,
    };
  }

  // ==========================================================
  // 3. MANTIDO: Seu método copyWith Original
  // ==========================================================
  Reserva copyWith({
    String? id,
    String? quartoId,
    String? clienteId,
    DateTime? dataEntrada,
    DateTime? dataSaida,
    double? valorTotal,
    String? status,
    int? numHospedes, // Adicionei aqui nos argumentos para funcionar
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