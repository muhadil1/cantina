import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';

class SignupViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  SignupViewModel(this._authRepository);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para registar novo utilizador
  Future<bool> signUp({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notifica a View que o estado de loading mudou

    try {
      await _authRepository.signUpWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners(); // Notifica sucesso
      return true; // Registo bem-sucedido
    } catch (e) {
      _isLoading = false;
      // Mensagem de erro genérica ou tratar e adaptar com base na exceção 'e'
      _errorMessage = "Erro ao registar. Email já em uso ou password fraca.";
      notifyListeners(); // Notifica a View que o estado de loading e erro mudaram
      return false; // Registo falhou
    }
  }
}