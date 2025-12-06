import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CADASTRAR USUÁRIO
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
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

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

      return null;
    } on FirebaseAuthException catch (e) {
      print("Erro FirebaseAuth: ${e.code} - ${e.message}");

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

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Login
  Future<String?> signInUser({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      return null;
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

  // Atualizar dados do usuário
  Future<String?> atualizarDadosUsuario({
    required String uid,
    required Map<String, dynamic> dados,
  }) async {
    try {
      await _firestore.collection('usuario').doc(uid).update(dados);
      return null;
    } on FirebaseException catch (e) {
      return e.message ?? "Erro ao atualizar dados.";
    } catch (e) {
      return e.toString();
    }
  }

  // Deletar usuário
  Future<String?> deleteUser() async {
    User? user = _auth.currentUser;
    if (user == null) return "Nenhum usuário logado.";

    try {
      await _firestore.collection('usuario').doc(user.uid).delete();
      await user.delete();

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return "É necessário logar novamente para excluir a conta.";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Redefinir senha
  Future<String?> redefinirSenha({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
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

  // Confirmar redefnição de senha
  Future<String?> confirmarRedefinicaoSenha({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  //Alterar senha
  Future<String?> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    User? user = _auth.currentUser;
    if (user == null || user.email == null) return "Usuário não identificado.";

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: senhaAtual,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(novaSenha);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'A senha atual está incorreta.';
      } else if (e.code == 'weak-password') {
        return 'A nova senha é muito fraca.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Buscar dados do usuário
  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return null;

    try {
      DocumentSnapshot doc = await _firestore
          .collection('usuario')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
    return null;
  }

  User? get currentUser => _auth.currentUser;
}
