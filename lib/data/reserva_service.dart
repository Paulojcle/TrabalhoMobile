import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quarto.dart';
import '../models/reserva.dart'; // ⚠️ Certifique-se de ter este modelo criado!

class ReservaService {
  // Use 10.0.2.2 para emulador Android.
  // Se for celular físico, use o IP do seu PC (ex: 192.168.1.5).
  static const String baseUrl = 'http://localhost:8000';

  // ===========================================================================
  // 1. BUSCAR TODOS OS QUARTOS (Usado na Home)
  // ===========================================================================
  Future<List<Quarto>> buscarTodosQuartos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/quartos/'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) {
          _corrigirUrlImagem(item); // Ajuste técnico para imagem
          return Quarto.fromJson(item);
        }).toList();
      } else {
        throw Exception('Erro ao carregar quartos: ${response.statusCode}');
      }
    } catch (e) {
      print("Erro buscarTodosQuartos: $e");
      return [];
    }
  }

  // ===========================================================================
  // 2. BUSCAR QUARTOS DISPONÍVEIS (Por data)
  // ===========================================================================
  Future<List<Quarto>> buscarQuartosDisponiveis(DateTime dataEntrada, DateTime dataSaida) async {
    // Formata datas para YYYY-MM-DD
    String entrada = dataEntrada.toIso8601String().split('T')[0];
    String saida = dataSaida.toIso8601String().split('T')[0];

    // O Django deve estar preparado para receber ?checkin=...&checkout=...
    final uri = Uri.parse('$baseUrl/api/quartos/').replace(queryParameters: {
      'checkin': entrada,
      'checkout': saida,
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) {
          _corrigirUrlImagem(item);
          return Quarto.fromJson(item);
        }).toList();
      } else {
        throw Exception('Erro ao buscar disponíveis: ${response.statusCode}');
      }
    } catch (e) {
      print("Erro buscarQuartosDisponiveis: $e");
      return [];
    }
  }

  // ===========================================================================
  // 3. BUSCAR MINHAS RESERVAS
  // ===========================================================================
  Future<List<Reserva>> buscarMinhasReservas(String clienteId) async {
    try {
      // Filtra reservas pelo ID do cliente (Django filter)
      final response = await http.get(Uri.parse('$baseUrl/api/reservas/?cliente=$clienteId'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        // ATENÇÃO: Seu modelo Reserva precisa ter o método .fromJson
        return body.map((item) => Reserva.fromJson(item)).toList();
      } else {
        // Se der 404 ou lista vazia, retornamos lista vazia sem erro
        return [];
      }
    } catch (e) {
      print("Erro buscarMinhasReservas: $e");
      return [];
    }
  }

  // ===========================================================================
  // 4. BUSCAR RESERVA POR ID
  // ===========================================================================
  Future<Reserva> buscarReservaPorId(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/reservas/$id/'));

      if (response.statusCode == 200) {
        return Reserva.fromJson(json.decode(response.body));
      } else {
        throw Exception('Reserva não encontrada');
      }
    } catch (e) {
      throw Exception('Erro ao buscar reserva: $e');
    }
  }

  // ===========================================================================
  // 5. CRIAR NOVA RESERVA
  // ===========================================================================
  Future<String> criarNovaReserva(Reserva reserva) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/reservas/'),
        headers: {"Content-Type": "application/json"},
        // ATENÇÃO: Seu modelo Reserva precisa ter o método .toJson
        body: json.encode(reserva.toJson()),
      );

      if (response.statusCode == 201) {
        final body = json.decode(response.body);
        // Retorna o ID da reserva criada (ajuste a chave 'id' conforme seu JSON)
        return body['id'].toString(); 
      } else {
        throw Exception('Falha ao criar reserva: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao criar reserva: $e');
    }
  }

  // ===========================================================================
  // 6. CANCELAR RESERVA
  // ===========================================================================
  Future<void> cancelarReserva(String reservaId) async {
    try {
      // Tenta deletar a reserva
      final response = await http.delete(Uri.parse('$baseUrl/api/reservas/$reservaId/'));

      // 204 = No Content (Sucesso na deleção) ou 200 = OK
      if (response.statusCode == 204 || response.statusCode == 200) {
        return; // Sucesso
      } else {
        throw Exception('Não foi possível cancelar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao cancelar reserva: $e');
    }
  }

  // --- Helper para corrigir URL de imagens ---
  void _corrigirUrlImagem(Map<String, dynamic> item) {
    if (item['imagens'] != null && !item['imagens'].toString().startsWith('http')) {
      item['imagens'] = '$baseUrl${item['imagens']}';
    }
  }
}