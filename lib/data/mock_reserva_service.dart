// lib/data/mock_reserva_service.dart

import 'reserva_service.dart';
import '../models/reserva.dart';
import '../models/quarto.dart';

// --- IMPLEMENTAÇÃO MOCK (PARA TESTES) ---
class MockReservaService implements ReservaService {
  // Simulação de dados (ADICIONE SEUS DADOS AQUI)
  final List<Reserva> _reservasMock = [];
  final List<Quarto> _quartosMock = [
    // Exemplo de Quarto
    const Quarto(
      id: 'Q001',
      tipo: 'Suíte Presidencial',
      preco: 550.0,
      descricao: 'Vista panorâmica e banheira de hidromassagem.',
      // ATENÇÃO: Adicione maxHospedes/capacidade para a correção anterior funcionar!
      capacidade: 4,
      disponivel: true,
      avaliacao: 4.5,
      imageUrl:
          'https://images.pexels.com/photos/271618/pexels-photo-271618.jpeg',
    ),
    const Quarto(
      id: 'Q002',
      tipo: 'Quarto Família',
      preco: 280.0,
      descricao: 'Espaçoso, ideal para famílias grandes.',
      capacidade: 5,
      disponivel: true,
      avaliacao: 4.8,
      imageUrl:
          'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg',
    ),
  ];

  // Simula um atraso de rede
  Future<T> _simulateDelay<T>(T result) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return result;
  }

  // Implementação de todos os métodos do contrato:

  @override
  Future<List<Quarto>> buscarTodosQuartos() {
    return _simulateDelay(_quartosMock);
  }

  @override
  Future<List<Quarto>> buscarQuartosDisponiveis(
    DateTime dataEntrada,
    DateTime dataSaida,
  ) {
    // Retorna todos os mock rooms como disponíveis por padrão
    return _simulateDelay(_quartosMock);
  }

  @override
  Future<String> criarNovaReserva(Reserva reserva) async {
    await Future.delayed(const Duration(milliseconds: 500));
    String novoId = 'RES-${DateTime.now().millisecondsSinceEpoch}';
    final novaReservaComId = reserva.copyWith(
      id: novoId,
      status: 'Confirmada',
    ); // Adicionando status inicial
    _reservasMock.add(novaReservaComId);
    return novoId;
  }

  @override
  Future<Reserva> buscarReservaPorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _reservasMock.firstWhere(
      (r) => r.id == id,
      orElse: () => throw Exception("Reserva com ID '$id' não encontrada."),
    );
  }

  @override
  Future<List<Reserva>> buscarMinhasReservas(String clienteId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _reservasMock;
  }

  // ⬅️ NOVO MÉTODO IMPLEMENTADO
  @override
  Future<void> cancelarReserva(String reservaId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simula delay

    final index = _reservasMock.indexWhere((r) => r.id == reservaId);

    if (index == -1) {
      throw Exception(
        "Reserva com ID '$reservaId' não encontrada para cancelamento.",
      );
    }

    final reservaOriginal = _reservasMock[index];

    // Se já estiver cancelada, não faz nada (ou lança um erro, dependendo da regra de negócio)
    if (reservaOriginal.status == 'Cancelada') {
      return;
    }

    // Cria uma nova cópia com o status atualizado
    final reservaCancelada = reservaOriginal.copyWith(status: 'Cancelada');

    // Substitui a reserva antiga pela nova (cancelada) na lista mock
    _reservasMock[index] = reservaCancelada;

    // Finaliza com sucesso (retorna Future<void>)
  }
}
