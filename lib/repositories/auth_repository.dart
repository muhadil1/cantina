import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepository(this._firebaseAuthService);

  // Método para registar utilizador
  Future<AppUser?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      User? firebaseUser = await _firebaseAuthService.signUpWithEmailAndPassword(email, password);
      return AppUser.fromFirebaseUser(firebaseUser);
    } catch (e) {
      // Tratar ou relançar exceções de forma mais genérica se necessário
      print('Error during sign up: $e');
      rethrow;
    }
  }

  // Método para fazer login
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      User? firebaseUser = await _firebaseAuthService.signInWithEmailAndPassword(email, password);
      return AppUser.fromFirebaseUser(firebaseUser);
    } catch (e) {
      // Tratar ou relançar exceções de forma mais genérica se necessário
      print('Error during sign in: $e');
      rethrow;
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    try {
      print('AuthRepository: Attempting to sign out...');
      await _firebaseAuthService.signOut();
      print('AuthRepository: Sign out successful.');
    } catch (e) {
      print('AuthRepository: Error during sign out: $e');
      rethrow;
    }
  }

  // Stream para observar o estado de autenticação, mapeando para AppUser
  Stream<AppUser?> get user {
    return _firebaseAuthService.authStateChanges.map((firebaseUser) {
      // >>> MUDANÇA AQUI <<<
      if (firebaseUser == null) {
        return null; // Se o utilizador do Firebase for null, emitir null no nosso stream
      }
      // Caso contrário, mapear para o nosso AppUser
      return AppUser.fromFirebaseUser(firebaseUser);
    });
  }
}