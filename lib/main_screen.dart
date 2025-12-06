import 'package:flutter/material.dart';
import 'package:hotel_app/pages/home_page.dart';
import 'pages/confirmation_reserva.dart';
import 'pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'servicos/auth_guard.dart';
import 'pages/configuration_page.dart';
import 'data/reserva_service.dart';
import 'pages/listar_reservas.dart';

class MainScreen extends StatefulWidget {
  final int indexInicial;
  const MainScreen({super.key, this.indexInicial = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Criamos a instância do serviço REAL aqui
  final ReservaService _reservaService = ReservaService();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.indexInicial;

    _pages = [
      HomePage(reservaService: _reservaService),

      /* MENÚ: MINHAS RESERVAS */
      ListarReservasPage(reservaService: _reservaService),

      /* MENÚ: CONFIGURAÇÕES */
      ConfigurationPage(),

      /* MENÚ: PERFIL */
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) async {
    if (index == 3) {
      bool permitido = await requireLogin(context);
      if (!permitido) return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Como inicializamos _pages no initState, podemos usar sem problemas
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF192C50),
        unselectedItemColor: const Color(0xFFC1C1C1),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config.'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
