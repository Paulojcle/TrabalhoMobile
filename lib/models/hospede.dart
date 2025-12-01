// lib/models/hospede.dart

class Hospede {
  final String? id; // ID do Django (pode ser nulo antes de criar)
  final String uidFirebase; // Para vincular o login social ao banco SQL
  final String nome;
  final String email;
  final String? telefone;
  final String? cpf;

  Hospede({
    this.id,
    required this.uidFirebase,
    required this.nome,
    required this.email,
    this.telefone,
    this.cpf,
  });

  // Converte JSON da API para Objeto Dart
  factory Hospede.fromJson(Map<String, dynamic> json) {
    return Hospede(
      id: json['id']?.toString(),
      uidFirebase: json['uid_firebase'] ?? '', // Certifique-se que o Django tem esse campo
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'],
      cpf: json['cpf'],
    );
  }

  // Converte Objeto Dart para JSON (para enviar ao Django)
  Map<String, dynamic> toJson() {
    return {
      // O Django espera 'cpf' como chave primária.
      'cpf': cpf, 
      'nome': nome,
      'telefone': telefone ?? '',
      'email': email,
      'uid_firebase': uidFirebase,
      'ativo': true, // Forçamos ativo ao criar via app
    };
  }
}