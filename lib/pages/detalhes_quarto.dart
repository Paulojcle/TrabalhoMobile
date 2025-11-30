import 'package:flutter/material.dart';
import 'fazer_reserva.dart';
import '../data/reserva_service.dart';
import '../models/quarto.dart';

class DetalhesQuartoPage extends StatefulWidget {
  final Quarto quarto;
  final ReservaService reservaService;
  const DetalhesQuartoPage({
    super.key,
    required this.quarto,
    required this.reservaService,
  });

  @override
  State<DetalhesQuartoPage> createState() => _DetalhesQuartoPageState();
}

class _DetalhesQuartoPageState extends State<DetalhesQuartoPage> {
  // Controle do índice da imagem atual
  int _currentImageIndex = 0;

  // Cores do tema
  final Color _primaryColor = const Color(0xFF0B2A4A);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _textColor = const Color(0xFF333333);

  // Lista de imagens (Usando a URL do quarto, mas mantendo a lista para o carrossel.
  // Se o seu model 'Quarto' não tem uma lista de URLs, usaremos apenas a 'imageUrl')
  late final List<String> _images;

  @override
  void initState() {
    super.initState();
    // Se o seu modelo Quarto tiver uma lista de imagens (imageUrls), use-a.
    // Caso contrário, usamos a imageUrl como uma lista de um item para o PageView.
    // Estou usando a 'imageUrl' como um item de uma lista temporária para manter o carrossel.
    _images = [widget.quarto.imageUrl];
    // Se você tiver uma lista de URLs no seu modelo Quarto (ex: widget.quarto.imageUrls), use:
    // _images = widget.quarto.imageUrls.isNotEmpty ? widget.quarto.imageUrls : [widget.quarto.imageUrl];
  }

  // Função auxiliar para formatação manual de moeda
  String _formatarMoeda(double valor) {
    String valorString = valor.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $valorString';
  }

  @override
  Widget build(BuildContext context) {
    // ⬅️ Dados dinâmicos
    final Quarto quarto = widget.quarto;
    final String precoFormatado = _formatarMoeda(quarto.preco);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          // 1. CONTEÚDO COM SCROLL
          SingleChildScrollView(
            // Adiciona padding no fundo para o conteúdo não ficar atrás do rodapé fixo
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === CARROSSEL DE IMAGENS ===
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            _images[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF0B2A4A),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Gradiente Base
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Indicador de Páginas (Bolinhas)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_images.length, (index) {
                          return AnimatedContainer(
                            // Animação suave na troca
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentImageIndex == index ? 22 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Contador de Fotos (Ex: 1/1)
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${_currentImageIndex + 1} / ${_images.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // === INFORMAÇÕES DO QUARTO ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título e Nota
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              // ⬅️ DADOS DINÂMICOS: Título do Quarto
                              quarto.tipo,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _textColor,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Avaliação (Mantido mock, pois não está no modelo Quarto)
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "4.8 (10 avaliações)",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),

                      const SizedBox(height: 25),
                      const Divider(height: 1),
                      const SizedBox(height: 25),

                      // Detalhes (Hóspedes / Banheiros)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _IconDetail(
                            icon: Icons.people_alt_rounded,
                            // ⬅️ DADOS DINÂMICOS: Hóspedes
                            label: "${quarto.capacidade} Hóspedes",
                          ),
                          _IconDetail(
                            icon: Icons.bathtub_outlined,
                            label: "3 Banheiros", // Mock
                          ),
                          _IconDetail(
                            icon: Icons.square_foot_rounded,
                            label: "80m²", // Mock
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),
                      const Divider(height: 1),
                      const SizedBox(height: 25),

                      // === O QUE ESSE LUGAR OFERECE ===
                      Text(
                        "O que esse lugar oferece",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Lista de serviços em Grid/Wrap (Mocked)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: const [
                          _ServiceChip(icon: Icons.wifi, label: "Wifi Rápido"),
                          _ServiceChip(
                            icon: Icons.local_parking_rounded,
                            label: "Estacionamento",
                          ),
                          _ServiceChip(
                            icon: Icons.pool_rounded,
                            label: "Piscina",
                          ),
                          _ServiceChip(
                            icon: Icons.ac_unit_rounded,
                            label: "Ar Condicionado",
                          ),
                          _ServiceChip(
                            icon: Icons.tv_rounded,
                            label: "Smart TV",
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),
                      const Divider(height: 1),
                      const SizedBox(height: 25),

                      // === DESCRIÇÃO ===
                      Text(
                        "Sobre a acomodação",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        // ⬅️ DADOS DINÂMICOS: Descrição do Quarto
                        quarto.descricao,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. BOTÕES FLUTUANTES SUPERIORES (Voltar e Favoritar)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botão Voltar
                _CircleButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                // Botão Favoritar (Mocked)
                _CircleButton(
                  icon: Icons.favorite_border,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Adicionado aos favoritos!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 3. RODAPÉ FIXO (PREÇO + RESERVAR)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Preço
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // ⬅️ DADOS DINÂMICOS: Preço formatado
                          precoFormatado,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                        Text(
                          "/noite",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // Botão Reservar
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para navegar para a próxima tela de reserva
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FazerReservaPage(
                              // ⬅️ PASSANDO O SERVIÇO E O QUARTO
                              reservaService: widget.reservaService,
                              quarto: quarto,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 25,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Reservar Agora",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// WIDGETS AUXILIARES (DECORAÇÃO MANTIDA)
// =======================================================

// 1. Botão Circular Transparente (Topo)
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
    );
  }
}

// 2. Detalhe com Ícone (Cama, Banheiro)
class _IconDetail extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconDetail({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: const Color(0xFF0B2A4A)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
      ],
    );
  }
}

// 3. Chip de Serviço (Wifi, Piscina)
class _ServiceChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ServiceChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
