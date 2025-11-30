// lib/models/reserva.dart (Completo e Corrigido)

class Reserva {
  final String id;
  final String quartoId;
  final String clienteId;
  final DateTime dataEntrada;
  final DateTime dataSaida;
  final double valorTotal;
  final String status;
  final int numHospedes; // ⬅️ CORRIGIDO: Tornado opcional

  const Reserva({
    required this.id,
    required this.quartoId,
    required this.clienteId,
    required this.dataEntrada, // ⬅️ OBRIGATÓRIO (como visto nos erros anteriores)
    required this.dataSaida,
    required this.valorTotal,
    required this.status,
    required this.numHospedes,
  });

  // ⬅️ CORRIGIDO: Método copyWith Adicionado
  Reserva copyWith({
    String? id,
    String? quartoId,
    String? clienteId,
    DateTime? dataEntrada,
    DateTime? dataSaida,
    double? valorTotal,
    String? status,
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
