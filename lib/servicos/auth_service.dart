import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cadastrar usuário
  Future<String?> registerUser({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
  }) async {
    try {
      // 1. Tenta criar o usuário
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // 2. Tenta salvar no Firestore
      await _firestore.collection('usuario').doc(userCred.user!.uid).set({
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'dataCadastro': DateTime.now(),
      });

      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      // Printa o erro exato no console (olhe o terminal do VSCode/Android Studio)
      print("Erro FirebaseAuth: ${e.code} - ${e.message}");
      
      // Retorna mensagens traduzidas comuns
      switch (e.code) {
        case 'email-already-in-use':
          return 'O email já está cadastrado.';
        case 'weak-password':
          return 'A senha é muito fraca (mínimo 6 caracteres).';
        case 'invalid-email':
          return 'O email é inválido.';
        default:
          return e.message ?? "Erro desconhecido no Firebase.";
      }
    } catch (e) {
      // Erro genérico (pode ser Firestore ou erro de código)
      print("Erro Geral: $e");
      return "Ocorreu um erro ao cadastrar: $e";
    }
  }

  User? get currentUser => _auth.currentUser;
}