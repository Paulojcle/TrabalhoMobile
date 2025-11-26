import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/pages/login_page.dart';
import '/pages/cadastro.dart';

Future<bool> requireLogin(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroPage()),   /* Aqui deve colocar a página de LOGIN -> LoginPage()*/
    );
    return false; // Não está logado
  }

  return true; // Está logado
}
