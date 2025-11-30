// lib/data/reserva_service.dart

import '../models/reserva.dart';
import '../models/quarto.dart';

// --- CONTRATO (ABSTRACT CLASS) ---
abstract class ReservaService {
  Future<List<Quarto>> buscarTodosQuartos();
  Future<List<Quarto>> buscarQuartosDisponiveis(
    DateTime dataEntrada,
    DateTime dataSaida,
  );
  Future<List<Reserva>> buscarMinhasReservas(String clienteId);
  Future<Reserva> buscarReservaPorId(String id);
  Future<String> criarNovaReserva(
    Reserva reserva,
  ); // Retorna o ID da nova reserva

  // ⬅️ NOVO MÉTODO PARA CANCELAMENTO
  Future<void> cancelarReserva(String reservaId);
  // Usa Future<void> porque a operação não retorna dados, apenas confirma o sucesso ou falha.
}
