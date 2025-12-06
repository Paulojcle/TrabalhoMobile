class Hospede {
  final String? id;
  final String uidFirebase;
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
      uidFirebase: json['uid_firebase'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'],
      cpf: json['cpf'],
    );
  }

  // Converte Objeto Dart para JSON (para enviar ao Django)
  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'nome': nome,
      'telefone': telefone ?? '',
      'email': email,
      'uid_firebase': uidFirebase,
      'ativo': true,
    };
  }
}
