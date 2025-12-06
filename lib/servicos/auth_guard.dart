import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/pages/login_page.dart';

Future<bool> requireLogin(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    return false;
  }

  return true; // Se retornar true é pq está logado
}
