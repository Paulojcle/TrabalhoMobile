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

  // LER DO DJANGO (GET)

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'].toString(),
      quartoId: json['quarto'].toString(),
      clienteId: (json['hospede'] ?? json['cliente'] ?? '').toString(),
      dataEntrada: DateTime.parse(
        json['dtEntrada'] ?? json['checkin'] ?? DateTime.now().toString(),
      ),
      dataSaida: DateTime.parse(
        json['dtSaida'] ?? json['checkout'] ?? DateTime.now().toString(),
      ),

      valorTotal:
          double.tryParse(json['valor_total']?.toString() ?? '0') ?? 0.0,

      status: json['status'] ?? 'Pendente',

      numHospedes:
          int.tryParse(
            (json['quantPessoas'] ?? json['numero_hospedes']).toString(),
          ) ??
          1,
    );
  }

  // ENVIAR PARA O DJANGO (POST)

  Map<String, dynamic> toJson() {
    return {
      // Se tiver ID, envia (edição), senão ignora
      if (id.isNotEmpty) 'id': id,
      'quarto': int.tryParse(quartoId),
      'hospede': clienteId,
      'dtEntrada': dataEntrada.toIso8601String().split('T')[0],
      'dtSaida': dataSaida.toIso8601String().split('T')[0],
      'quantPessoas': numHospedes,
      'valor_total': valorTotal,
      'status': status,
    };
  }

  // COPY WITH

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
