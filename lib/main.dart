import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
// ADICIONE ESTES IMPORTS:
import 'package:app_links/app_links.dart'; 
import 'pages/redefinir_senha.dart'; // <--- Verifique se o caminho está correto

// 1. Crie esta chave global fora das classes
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Ouve os links que chegam enquanto o app está aberto ou iniciando
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        print("Link recebido: $uri");
        _processarLink(uri);
      }
    });
  }

  void _processarLink(Uri uri) {
    // Tenta pegar o código diretamente
    String? oobCode = uri.queryParameters['oobCode'];

    // O Firebase às vezes embrulha o link em um parâmetro 'link'.
    // Ex: https://seuapp.page.link/?link=https://...?oobCode=XYZ
    if (oobCode == null && uri.queryParameters.containsKey('link')) {
      try {
        final innerUri = Uri.parse(uri.queryParameters['link']!);
        oobCode = innerUri.queryParameters['oobCode'];
      } catch (e) {
        print("Erro ao analisar link interno: $e");
      }
    }

    // Se encontrou o código, navega para a tela de redefinição
    if (oobCode != null) {
      // Usa a navigatorKey para navegar sem context
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => RedefinirSenhaPage(oobCode: oobCode!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 2. Conecte a chave global aqui
      navigatorKey: navigatorKey,
      
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}