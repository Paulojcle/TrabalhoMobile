class Quarto {
  final String id;
  final String tipo;
  final double preco;
  final String descricao;
  final int capacidade;
  final int camas;
  final int banheiros;
  final bool disponivel;
  final String? imageUrl;
  final double avaliacao;

  const Quarto({
    required this.id,
    required this.tipo,
    required this.preco,
    required this.descricao,
    required this.capacidade,
    required this.camas,
    required this.banheiros,
    this.imageUrl,
    required this.avaliacao,
    this.disponivel = true,
  });

  factory Quarto.fromJson(Map<String, dynamic> json) {
    return Quarto(
      // Django envia 'numero' (int), Flutter quer String 'id'
      id: json['numero'].toString(),

      tipo: json['tipo'] ?? 'Padrão',

      // Django envia 'preco_diaria' (string/decimal), Flutter quer double
      preco: double.tryParse(json['preco_diaria'].toString()) ?? 0.0,

      descricao: json['descricao_detalhada'] ?? '',
      capacidade: json['capacidade'] ?? 0,
      camas: json['camas'] ?? 0,
      banheiros: json['banheiros'] ?? 0,

      // Se não tiver imagem, enviamos null
      imageUrl: json['imagens'],

      avaliacao: double.tryParse(json['avaliacao'].toString()) ?? 0.0,
      disponivel: json['disponibilidade'] ?? true,
    );
  }
}
