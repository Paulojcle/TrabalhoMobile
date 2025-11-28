import 'package:flutter/material.dart';
import 'package:hotel_app/pages/detalhes_quarto.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final Color _primaryColor = const Color(0xFF0B2A4A);
  final Color _backgroundColor = const Color(0xFFF8F9FA);

  // =======================================================
  // 1. LÓGICA DO MODAL DE NOTIFICAÇÕES (SININHO)
  // =======================================================
  void _openNotificationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ocupa apenas o espaço necessário
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barrinha cinza no topo (indicador de arraste)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              const Text(
                "Notificações",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              
              // Lista de Notificações Fake
              Expanded(
                child: ListView(
                  children: [
                    _NotificationItem(
                      title: "Reserva Confirmada!",
                      subtitle: "Sua estadia na Suíte Master foi aprovada.",
                      time: "2 min atrás",
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                    ),
                    _NotificationItem(
                      title: "Promoção Relâmpago",
                      subtitle: "50% de desconto em quartos Deluxe hoje.",
                      time: "1 hora atrás",
                      icon: Icons.local_offer,
                      iconColor: Colors.amber,
                    ),
                    _NotificationItem(
                      title: "Lembrete de Check-in",
                      subtitle: "Não se esqueça do seu check-in amanhã.",
                      time: "5 horas atrás",
                      icon: Icons.access_time_filled,
                      iconColor: _primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =======================================================
  // 2. LÓGICA DO MODAL DE FILTROS (CAMA/BANHEIRO)
  // =======================================================
  void _openFilterModal(BuildContext context) {
    // Valores iniciais
    int camas = 1;
    int banheiros = 1;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        // StatefulBuilder permite atualizar a tela DENTRO do modal
        // sem precisar transformar a HomePage inteira em StatefulWidget
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  const Text("Filtros de Quarto", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),

                  // CONTADOR DE CAMAS
                  _buildCounterRow(
                    label: "Camas",
                    value: camas,
                    onDecrement: () {
                      if (camas > 1) setStateModal(() => camas--);
                    },
                    onIncrement: () {
                      setStateModal(() => camas++);
                    },
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // CONTADOR DE BANHEIROS
                  _buildCounterRow(
                    label: "Banheiros",
                    value: banheiros,
                    onDecrement: () {
                      if (banheiros > 1) setStateModal(() => banheiros--);
                    },
                    onIncrement: () {
                      setStateModal(() => banheiros++);
                    },
                  ),

                  const SizedBox(height: 40),

                  // BOTÃO DE APLICAR
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Aqui você aplicaria a lógica de filtro real
                        Navigator.pop(context); // Fecha o modal
                        print("Filtros aplicados: Camas: $camas, Banheiros: $banheiros");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Aplicar Filtros", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper para desenhar a linha do contador (+ 1 -)
  Widget _buildCounterRow({required String label, required int value, required VoidCallback onDecrement, required VoidCallback onIncrement}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        Row(
          children: [
            _RoundButton(icon: Icons.remove, onTap: onDecrement),
            SizedBox(width: 20, child: Center(child: Text("$value", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
            _RoundButton(icon: Icons.add, onTap: onIncrement),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset('assets/logo.png', height: 40, errorBuilder: (c, e, s) => Text("SleepWell", style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold))),
        actions: [
          // AÇÃO DO SININHO
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: _primaryColor),
            onPressed: () => _openNotificationModal(context), // <--- CHAMA O MODAL AQUI
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Encontre sua\nestadia perfeita",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
                height: 1.2,
              ),
            ),
            
            const SizedBox(height: 20),

            // BARRA DE PESQUISA COM BOTÃO DE FILTRO
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Para onde você vai?",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                  prefixIcon: Icon(Icons.search_rounded, color: _primaryColor),
                  
                  // AÇÃO DO BOTÃO DE FILTRO
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune_rounded, color: _primaryColor, size: 20),
                      onPressed: () => _openFilterModal(context), // <--- CHAMA O MODAL AQUI
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // TÍTULO DA SEÇÃO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Populares", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                TextButton(onPressed: (){}, child: const Text("Ver todos", style: TextStyle(color: Colors.grey)))
              ],
            ),

            const SizedBox(height: 10),

            // LISTA DE QUARTOS
            _HotelCard(
              imageUrl: 'assets/quarto.png',
              title: 'Suíte Master com vista para a barragem Ceraíma',
              rating: '4,8',
              guests: '3',
              beds: '2',
              price: 'R\$1.600,50',
              primaryColor: _primaryColor,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DetalhesQuartoPage()));
              },
            ),
            
            const SizedBox(height: 20),

            _HotelCard(
              imageUrl: 'assets/quarto.png',
              title: 'Quarto Deluxe Casal',
              rating: '4,5',
              guests: '2',
              beds: '1',
              price: 'R\$850,00',
              primaryColor: _primaryColor,
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const DetalhesQuartoPage()));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// WIDGETS AUXILIARES
// =======================================================

// 1. CARD DE HOTEL (Já refinado anteriormente)
class _HotelCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String rating;
  final String guests;
  final String beds;
  final String price;
  final Color primaryColor;
  final VoidCallback onTap;

  const _HotelCard({required this.imageUrl, required this.title, required this.rating, required this.guests, required this.beds, required this.price, required this.primaryColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), spreadRadius: 0, blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(height: 180, color: Colors.grey[300], child: const Icon(Icons.image, color: Colors.grey))),
                ),
                Positioned(
                  top: 15, right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star_rounded, color: Colors.amber, size: 16), const SizedBox(width: 4), Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))]),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF333333), height: 1.3)),
                  const SizedBox(height: 12),
                  Row(children: [_IconText(icon: Icons.bed_rounded, text: beds), const SizedBox(width: 15), _IconText(icon: Icons.people_alt_rounded, text: guests)]),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("A partir de", style: TextStyle(fontSize: 12, color: Colors.grey)), Text(price, style: TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.w800))]),
                      Container(decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: const Text('Ver quarto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. ITEM DE NOTIFICAÇÃO (Para o modal de notificações)
class _NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;

  const _NotificationItem({required this.title, required this.subtitle, required this.time, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. BOTÃO REDONDO (Para o modal de filtros + e -)
class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconText({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(icon, size: 18, color: Colors.grey[500]), const SizedBox(width: 6), Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500))]);
  }
}