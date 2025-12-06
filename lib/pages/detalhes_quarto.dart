import 'package:flutter/material.dart';
import 'fazer_reserva.dart';
import '../data/reserva_service.dart';
import '../models/quarto.dart';
import '../servicos/auth_guard.dart';

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
  int _currentImageIndex = 0;

  final Color _primaryColor = const Color(0xFF0B2A4A);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _textColor = const Color(0xFF333333);

  late final List<String> _images;

  @override
  void initState() {
    super.initState();
    String img =
        (widget.quarto.imageUrl != null && widget.quarto.imageUrl!.isNotEmpty)
        ? widget.quarto.imageUrl!
        : 'https://via.placeholder.com/400x300';

    _images = [img];
  }

  // Função auxiliar para formatação manual de moeda
  String _formatarMoeda(double valor) {
    String valorString = valor.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $valorString';
  }

  @override
  Widget build(BuildContext context) {
    final Quarto quarto = widget.quarto;
    final String precoFormatado = _formatarMoeda(quarto.preco);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_images.length, (index) {
                          return AnimatedContainer(
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
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

                      // Avaliação
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${quarto.avaliacao} (Classificação)",
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _IconDetail(
                            icon: Icons.people_alt_rounded,
                            label: "${quarto.capacidade} Hóspedes",
                          ),
                          _IconDetail(
                            icon: Icons.bathtub_outlined,
                            label: "${quarto.banheiros} Banheiros",
                          ),
                          _IconDetail(
                            icon: Icons.bed_rounded,
                            label: "${quarto.camas} Camas",
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),
                      const Divider(height: 1),
                      const SizedBox(height: 25),
                      Text(
                        "O que esse lugar oferece",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 15),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: const [
                          _ServiceChip(icon: Icons.wifi, label: "Wifi Grátis"),
                          _ServiceChip(
                            icon: Icons.local_parking_rounded,
                            label: "Estacionamento",
                          ),
                          _ServiceChip(
                            icon: Icons.ac_unit_rounded,
                            label: "Ar Condicionado",
                          ),
                          _ServiceChip(
                            icon: Icons.tv_rounded,
                            label: "TV a Cabo",
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),
                      const Divider(height: 1),
                      const SizedBox(height: 25),

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

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // RODAPÉ FIXO
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
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

                    ElevatedButton(
                      onPressed: () async {
                        bool isLoggedIn = await requireLogin(context);

                        if (!isLoggedIn) return;

                        if (!mounted) return;

                        // Navega para a tela de fazer reserva
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FazerReservaPage(
                              reservaService: widget.reservaService,
                              quarto: widget.quarto,
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
                      child: Text(
                        quarto.disponivel ? "Reservar Agora" : "Indisponível",
                        style: const TextStyle(
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

// WIDGETS AUXILIARES

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
