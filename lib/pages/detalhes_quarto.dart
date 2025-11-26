import 'package:flutter/material.dart';

class DetalhesQuartoPage extends StatelessWidget {
  const DetalhesQuartoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CARROSSEL DE IMAGENS
                  Container(
                    height: 260,
                    child: PageView(
                      scrollDirection: Axis.horizontal, // Direção horizontal
                      children: [
                        Image.network(
                          "https://images.pexels.com/photos/271618/pexels-photo-271618.jpeg",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Image.network(
                          "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TÍTULO
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Suíte Master com vista para a barragem Ceraíma",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // -------------------------
                  // AVALIAÇÕES
                  // -------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 5),
                        Text("4.1/5 • 10 avaliações"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ÍCONES CAMAS E BANHEIROS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.bed, size: 20),
                        SizedBox(width: 6),
                        Text("2 camas"),
                        SizedBox(width: 20),
                        Icon(Icons.bathtub, size: 20),
                        SizedBox(width: 6),
                        Text("3 banheiros"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // SERVIÇOS (Wifi, Estacionamento, Piscina)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.wifi, size: 22),
                            SizedBox(width: 10),
                            Text("Wifi"),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.local_parking, size: 22),
                            SizedBox(width: 10),
                            Text("Estacionamento"),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.pool, size: 22),
                            SizedBox(width: 10),
                            Text("Piscina"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // DESCRIÇÃO
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Descrição",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Lorem ipsum dolor sit amet. Cum aliquam quasi et "
                      "laboriosam dolores aut corporis itaque non velit rem eos "
                      "voluptates vitae. Sit suscipit cumque in illo reprehenderit "
                      "est obcaecati fuga. At maxime consequatur et dolorem odio "
                      "non rem reprehenderit aut molestiae similique. Sed minus "
                      "perspiciatis et placeat pariatur sit impedit ratione sed "
                      "accusamus unde.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(height: 1.4),
                    ),
                  ),

                  const SizedBox(height: 120),  
                ],
              ),
            ),

            // BOTÃO VOLTAR
            Positioned(
              top: 10,
              left: 10,
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // RODAPÉ (VALOR + BOTÃO RESERVAR) FIXO
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "R\$1.600,50/noite",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0B2A4A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Reservar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
