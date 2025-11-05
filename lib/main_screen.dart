import 'package:flutter/material.dart';
import 'package:app_hotel/pages/confirmation_reserva.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Página Início')),
    ConfirmacaoReserva(),
    Center(child: Text('Página Configurações')),
    Center(child: Text('Página Perfil')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mostra a página atual com base no _selectedIndex
      body: _pages[_selectedIndex],

      // Menu inferior fixo em todas as páginas
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF192C50),
        unselectedItemColor: Color(0xFFC1C1C1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Quartos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Config.',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}