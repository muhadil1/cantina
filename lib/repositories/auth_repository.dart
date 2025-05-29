import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final FirestoreService _firestoreService; // Injetar FirestoreService
  final String _usersCollection = 'users'; // Nome da coleção de utilizadores

  AuthRepository(this._firebaseAuthService, this._firestoreService);

  // >>> Adicionado: Método auxiliar para obter o documento do utilizador do Firestore <<<
  Future<AppUser?> _getAppUserFromFirestore(User? firebaseUser) async {
    if (firebaseUser == null) {
      return null;
    }
    try {
      DocumentSnapshot doc = await _firestoreService.getDocument(_usersCollection, firebaseUser.uid);
      if (doc.exists) {
        return AppUser.fromFirestore(doc); // Usar o novo factory fromFirestore
      } else {
        print('AuthRepository: User document not found for UID ${firebaseUser.uid}. Creating basic AppUser from Firebase Auth.');
        // Se o documento do utilizador não existir, retorna um AppUser básico apenas com dados do Auth.
        // O documento será criado no Firestore durante o signUp.
        return AppUser.fromFirebaseUser(firebaseUser);
      }
    } catch (e) {
      print('AuthRepository: Error fetching user document from Firestore: $e');
      // Em caso de erro ao buscar, retorna AppUser com dados do Auth apenas
      return AppUser.fromFirebaseUser(firebaseUser);
    }
  }
  // <<< FIM DA ADIÇÃO >>>

  // >>> Modificado: Método para criar conta (Sign Up) com apelido e criação de documento no Firestore <<<
  Future<AppUser?> signUpWithEmailAndPassword(
      String email,
      String password,
      String apelido, // <<< Adicionado: apelido
      ) async {
    try {
      User? firebaseUser = await _firebaseAuthService.signUpWithEmailAndPassword(email, password);

      if (firebaseUser != null) {
        // CRIAR O DOCUMENTO DO UTILIZADOR NA COLEÇÃO 'users' AQUI
        final newUserProfile = {
          'email': email,
          'apelido': apelido, // <<< Guardar o apelido
          'role': 'customer', // Definir o papel padrão para novos utilizadores
          'createdAt': FieldValue.serverTimestamp(), // Adicionar timestamp de criação
          // Pode adicionar outros campos iniciais aqui, como phone, deliveryAddress
        };
        await _firestoreService.setDocument(
          _usersCollection,
          firebaseUser.uid, // O UID do Firebase Auth como Document ID
          newUserProfile,
        );

        // Após criar o documento no Firestore, obter o AppUser completo
        AppUser? appUserWithRole = await _getAppUserFromFirestore(firebaseUser);

        // Tentar atualizar o token FCM para o novo utilizador
        if (appUserWithRole?.uid != null) {
          await updateUserFCMToken(appUserWithRole!.uid!);
        }

        return appUserWithRole;
      }
      return null;
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }
  // <<< FIM DA MODIFICAÇÃO/ADIÇÃO >>>


  // >>> Adicionado: Método para obter o token FCM e salvá-lo no documento do utilizador <<<
  Future<void> updateUserFCMToken(String userId) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        print('AuthRepository: Updating FCM token for user $userId: $fcmToken');
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
      // rethrow;
    }
  }

  // Adicionado: Método para lidar com a atualização do token FCM (se ele mudar)
  void listenToFCMTokenChanges() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print('AuthRepository: FCM Token refreshed: $newToken');
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await updateUserFCMToken(currentUser.uid);
      }
    });
  }
  // <<< FIM DA ADIÇÃO >>>

  // Método para fazer login
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      User? firebaseUser = await _firebaseAuthService.signInWithEmailAndPassword(email, password);
      // >>> MODIFICAÇÃO AQUI: Buscar o documento do utilizador após login <<<
      AppUser? appUserWithRole = await _getAppUserFromFirestore(firebaseUser);
      // <<< FIM DA MODIFICAÇÃO >>>

      // Atualizar token FCM após login (se o utilizador foi obtido com sucesso)
      if (appUserWithRole?.uid != null) {
        await updateUserFCMToken(appUserWithRole!.uid!);
      }

      return appUserWithRole; // Retorna o AppUser que agora inclui o papel (se o documento foi encontrado)
    } catch (e) {
      print('Error during sign in: $e');
      rethrow;
    }
  }

  // >>> Modificado: Stream para observar o estado de autenticação, agora buscando o role e apelido <<<
  Stream<AppUser?> get user {
    return _firebaseAuthService.authStateChanges.asyncMap((firebaseUser) async {
      // Isto acontece ao iniciar a app com login persistido, ou após logout/login
      return await _getAppUserFromFirestore(firebaseUser);
    });
  }
  // <<< FIM DA MODIFICAÇÃO >>>

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
}
