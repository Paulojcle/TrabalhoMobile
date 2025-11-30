// lib/models/quarto.dart (Exemplo de Modelo Mínimo)

class Quarto {
  final String id;
  final String tipo; // ⬅️ GARANTIR QUE ESTE CAMPO EXISTA
  final double preco;
  final String descricao;
  final int capacidade;
  final bool disponivel;
  final String imageUrl;
  final double avaliacao;

  const Quarto({
    required this.id,
    required this.tipo,
    required this.preco,
    required this.descricao,
    required this.capacidade,
    required this.imageUrl,
    required this.avaliacao,
    this.disponivel = true,
  });
}
