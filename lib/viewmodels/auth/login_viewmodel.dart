import 'package:flutter/material.dart';
import '../../../repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importar FirebaseAuth
import '../../models/user.dart'; // Importar AppUser

class LoginViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository);

  bool _isLoading = false;
  String? _errorMessage;
  AppUser? _authenticatedUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppUser? get authenticatedUser => _authenticatedUser; // <<< Adicionado: getter para o utilizador

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // A chamada agora retorna o AppUser com o papel e apelido
      _authenticatedUser = await _authRepository.signInWithEmailAndPassword(email, password);

      // Se o utilizador foi obtido com sucesso, o login foi bem-sucedido
      bool success = _authenticatedUser?.uid != null;

      if (success) {
        print('LoginViewModel: signIn successful. User Role: ${_authenticatedUser!.role}, Apelido: ${_authenticatedUser!.apelido}');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Tratar caso onde o signInWithEmailAndPassword pode não ter lançado erro,
        // mas nenhum utilizador foi retornado/encontrado no Firestore (muito raro).
        _isLoading = false;
        _errorMessage = "Credenciais inválidas ou perfil não encontrado.";
        print('LoginViewModel: signInWithEmailAndPassword failed or user document not found.');
        notifyListeners();
        return false;
      }

    } catch (e) {
      _isLoading = false;
      _errorMessage = "Erro ao fazer login. Verifique email/password.";
      print('LoginViewModel: Error during sign in process: $e');
      notifyListeners();
      return false;
    }
  }
}
