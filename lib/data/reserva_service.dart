import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart'; // Importante para o Token
import '../models/quarto.dart';
import '../models/reserva.dart';
import '../models/hospede.dart';

class ReservaService {
  
  // ===========================================================================
  // 1. CONFIGURAÇÃO DE URL (IP Dinâmico)
  // ===========================================================================
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    // Se for emulador Android
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8000'; 
    // Se for celular físico (troque pelo seu IP do ipconfig)
    return 'http://192.168.0.106:8000'; 
  }

  // ===========================================================================
  // 2. HELPER DE SEGURANÇA (O método que faltava!)
  // ===========================================================================
  Future<Map<String, String>> _getHeaders() async {
    // Pega o usuário logado no App
    User? user = FirebaseAuth.instance.currentUser;
    
    // Tenta pegar o token JWT atual
    String? token = await user?.getIdToken();

    return {
      "Content-Type": "application/json",
      // Se tiver token, envia no formato Bearer. Se não, não envia.
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // ===========================================================================
  // 3. BUSCAR TODOS OS QUARTOS (Público ou Protegido)
  // ===========================================================================
  Future<List<Quarto>> buscarTodosQuartos() async {
    try {
      // Se quiser proteger essa rota também, use _getHeaders(). 
      // Por enquanto, vou deixar público (headers vazio ou só json).
      final response = await http.get(Uri.parse('$baseUrl/api/quartos/'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) {
          _corrigirUrlImagem(item);
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
  // 4. BUSCAR DISPONIBILIDADE
  // ===========================================================================
  Future<List<Quarto>> buscarQuartosDisponiveis(DateTime dataEntrada, DateTime dataSaida) async {
    String entrada = dataEntrada.toIso8601String().split('T')[0];
    String saida = dataSaida.toIso8601String().split('T')[0];

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
  // 5. BUSCAR MINHAS RESERVAS (Protegido)
  // ===========================================================================
  Future<List<Reserva>> buscarMinhasReservas(String clienteId) async {
    try {
      // Aqui usamos o _getHeaders porque é dado sensível do usuário
      final headers = await _getHeaders();

      // No Django, você vai precisar filtrar isso. 
      // Se o Django usar o Token para saber quem é o usuário, nem precisa passar ?cliente=ID na URL.
      // Mas vamos manter a estrutura atual:
      final response = await http.get(
        Uri.parse('$baseUrl/api/reservas/?cliente=$clienteId/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) => Reserva.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erro buscarMinhasReservas: $e");
      return [];
    }
  }

  // ===========================================================================
  // 6. BUSCAR RESERVA POR ID (Protegido)
  // ===========================================================================
  Future<Reserva> buscarReservaPorId(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/reservas/$id/'),
        headers: headers,
      );

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
  // 7. SALVAR HÓSPEDE (Protegido com Token)
  // ===========================================================================
  Future<String> salvarHospede(Hospede hospede) async {
    try {
      final url = Uri.parse('$baseUrl/api/hospedes/');
      
      // ⚠️ AQUI ESTAVA O ERRO ANTES: Chamando a função _getHeaders
      final headers = await _getHeaders(); 

      final response = await http.post(
        url,
        headers: headers, // Envia o Token
        body: json.encode(hospede.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = json.decode(response.body);
        return body['id'].toString();
      } else {
        throw Exception('Erro API (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao salvar hóspede: $e');
    }
  }

  // ===========================================================================
  // 8. CRIAR NOVA RESERVA (Protegido com Token)
  // ===========================================================================
  Future<String> criarNovaReserva(Reserva reserva, Hospede dadosHospede) async {
    try {
      // 1. Salva Hóspede (Já usa token internamente)
      String clienteIdDjango = await salvarHospede(dadosHospede);

      // 2. Atualiza objeto
      Reserva reservaFinal = reserva.copyWith(clienteId: clienteIdDjango);

      // 3. Prepara Headers com Token
      final headers = await _getHeaders();

      // 4. Envia
      final response = await http.post(
        Uri.parse('$baseUrl/api/reservas/'),
        headers: headers,
        body: json.encode(reservaFinal.toJson()),
      );

      if (response.statusCode == 201) {
        final body = json.decode(response.body);
        return body['id'].toString(); 
      } else {
        throw Exception('Falha ao criar reserva: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro no processo de reserva: $e');
    }
  }

  // ===========================================================================
  // 9. CANCELAR RESERVA (Protegido)
  // ===========================================================================
  Future<void> cancelarReserva(String reservaId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/reservas/$reservaId/'),
        headers: headers,
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      } else {
        throw Exception('Erro ao cancelar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao cancelar reserva: $e');
    }
  }

  // --- Helper visual ---
  void _corrigirUrlImagem(Map<String, dynamic> item) {
    if (item['imagens'] != null && !item['imagens'].toString().startsWith('http')) {
      item['imagens'] = '$baseUrl${item['imagens']}';
    }
  }
}