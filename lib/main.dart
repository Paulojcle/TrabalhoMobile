import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_links/app_links.dart';
import 'pages/redefinir_senha.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
    String? oobCode = uri.queryParameters['oobCode'];

    if (oobCode == null && uri.queryParameters.containsKey('link')) {
      try {
        final innerUri = Uri.parse(uri.queryParameters['link']!);
        oobCode = innerUri.queryParameters['oobCode'];
      } catch (e) {
        print("Erro ao analisar link interno: $e");
      }
    }

    if (oobCode != null) {
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
      navigatorKey: navigatorKey,

      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
