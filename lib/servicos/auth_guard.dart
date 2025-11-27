import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/pages/login_page.dart';

Future<bool> requireLogin(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),   /* Aqui deve colocar a página de LOGIN -> LoginPage()*/
    );
    return false; // Não está logado
  }

  return true; // Está logado
}
