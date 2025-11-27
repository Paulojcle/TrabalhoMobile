import 'package:flutter/material.dart';
import 'package:hotel_app/pages/home_page.dart';
import 'pages/confirmation_reserva.dart';
import 'pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'servicos/auth_guard.dart';
import 'pages/configuration_page.dart';

class MainScreen extends StatefulWidget {
  final int indexInicial;
  const MainScreen({super.key, this.indexInicial = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    /* MENÚ: PÁGINA INICIAL */
    ConfirmacaoReserva(),
    /* MENÚ: QUARTOS */
    ConfigurationPage(),
    /* MENÚ: CONFIGURAÇÕES */
    ProfilePage(),
    /* MENÚ: PERFIL DO USUÁRIO */
    Center(
      child: Text('Página Perfil'),
    ) /* MENÚ: PERFIL (caso não logado, redirecionar para LOGIN) */,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.indexInicial; // inicializa com o índice recebido
  }

  void _onItemTapped(int index) async {
    if (index == 4) {
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Quartos'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config.'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
