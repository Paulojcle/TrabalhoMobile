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
    required String cpf,
    required String telefone,
    String? fotoUrl,
    required String dataNascimento,
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
        'cpf': cpf,
        'telefone': telefone,
        'dataNascimento': dataNascimento,
        'fotoUrl': fotoUrl,
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
      print("Erro Geral: $e");
      return "Ocorreu um erro ao cadastrar: $e";
    }
  }

  // Logout usuário
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Login usuário
  Future<String?> signInUser({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado para este email.';
        case 'wrong-password':
          return 'Senha incorreta. Tente novamente.';
        case 'invalid-email':
          return 'O formato do email é inválido.';
        case 'channel-error':
          return 'O email e a senha são obrigatórios.';
        default:
          return e.message ?? 'Erro desconhecido ao tentar logar.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // EXCLUIR CONTA
  Future<String?> deleteUser() async {
    User? user = _auth.currentUser;
    if (user == null) return "Nenhum usuário logado.";

    try {
      // 1. Exclui o documento do Firestore
      await _firestore.collection('usuario').doc(user.uid).delete();

      // 2. Exclui a conta do Firebase Auth
      await user.delete();
      
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return "É necessário logar novamente para excluir a conta.";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // === REDEFINIR SENHA EMAIL ===
  Future<String?> redefinirSenha({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Sucesso (null significa sem erros)
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Email não cadastrado.';
        case 'invalid-email':
          return 'Email inválido.';
        default:
          return e.message ?? 'Erro ao enviar email.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // === CONFIRMAR REDEFINIÇÃO DE SENHA (Deep Link) ===
  Future<String?> confirmarRedefinicaoSenha({required String code, required String newPassword}) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  User? get currentUser => _auth.currentUser;
}