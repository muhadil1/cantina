import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';

class SignupViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  SignupViewModel(this._authRepository);

  bool _isLoading = false;
  String? _errorMessage;
  String? _passwordMismatchError;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get passwordMismatchError => _passwordMismatchError;

  // Método para registar novo utilizador
  Future<bool> signUp({required String email, required String password, required String confirmPassword,
    required String apelido,}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notifica a View que o estado de loading mudou

    // >>> VALIDAÇÃO DA SENHA AQUI <<<
    if (password != confirmPassword) {
      _isLoading = false;
      _passwordMismatchError = "As senhas não coincidem."; // Definir mensagem de erro
      notifyListeners();
      return false;
    }
    // <<< FIM DA VALIDAÇÃO >>>

    try {
      await _authRepository.signUpWithEmailAndPassword(email, password, apelido);
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
