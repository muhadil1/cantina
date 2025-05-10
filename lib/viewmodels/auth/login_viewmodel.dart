import 'package:flutter/material.dart';
import '../../../repositories/auth_repository.dart';

class LoginViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para fazer login
  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notifica a View que o estado de loading mudou

    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners(); // Notifica sucesso
      return true; // Login bem-sucedido
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Erro ao fazer login. Verifique email/password."; // Mensagem de erro genérica ou tratar e
      // adaptar a mensagem com base na exceção 'e'
      notifyListeners(); // Notifica a View que o estado de loading e erro mudaram
      return false; // Login falhou
    }
  }

// Você pode adicionar um método semelhante para sign up aqui ou em um ViewModel separado
}