import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/firebase_auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/firestore_service.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final FirestoreService _firestoreService; // Injetar FirestoreService
  final String _usersCollection = 'users'; // Nome da coleção de utilizadores

  AuthRepository(this._firebaseAuthService, this._firestoreService);

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

  // Método para obter o token FCM e salvá-lo no documento do utilizador
  Future<void> updateUserFCMToken(String userId) async {
    try {
      // Obter o token FCM do dispositivo
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        print('AuthRepository: Updating FCM token for user $userId: $fcmToken');
        // Atualizar o documento do utilizador na coleção 'users' com o token
        await _firestoreService.updateDocument(
          _usersCollection,
          userId,
          {'fcmToken': fcmToken},
        );
        print('AuthRepository: FCM token updated successfully.');
      } else {
        print('AuthRepository: FCM token is null, cannot update.');
      }
    } catch (e) {
      print('AuthRepository: Error updating FCM token: $e');
      // Pode decidir não relançar este erro se a atualização do token não for crítica para o login
      // rethrow;
    }
  }

  // Método para lidar com a atualização do token FCM (se ele mudar)
  void listenToFCMTokenChanges() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print('AuthRepository: FCM Token refreshed: $newToken');
      // Quando o token refrescar, obter o utilizador atual e atualizar no Firestore
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await updateUserFCMToken(currentUser.uid);
      }
    });
  }

  // Método para fazer login
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      User? firebaseUser = await _firebaseAuthService.signInWithEmailAndPassword(email, password);
      AppUser? appUser = AppUser.fromFirebaseUser(firebaseUser);
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