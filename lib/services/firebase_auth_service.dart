import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Método para registar utilizador com email e password
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException {
      /*if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      // Relançar a exceção para ser tratada pelo Repositório/ViewModel
      rethrow;*/
    } catch (e) {
      /*print(e.toString());
      rethrow;*/
    }
    return null;
  }

  // Método para fazer login com email e password
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      print(
        'FirebaseAuthService: Sign in successful for user: ${credential.user?.email}',
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      // Relançar a exceção para ser tratada pelo Repositório/ViewModel
      rethrow;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    try {
      print('FirebaseAuthService: Attempting to sign out...');
      await _firebaseAuth.signOut();
      print('FirebaseAuthService: Sign out successful.');
    } catch (e) {
      print('FirebaseAuthService: Error during sign out: $e');
      rethrow;
    }
  }

  // Stream para observar o estado de autenticação
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
