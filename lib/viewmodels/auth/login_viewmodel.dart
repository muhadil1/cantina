import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../repositories/auth_repository.dart';
import '../../models/user.dart'; // Importar AppUser

class LoginViewModel with ChangeNotifier {
  final AuthRepository _authRepository;
  AppUser? _currentUser;

  LoginViewModel(this._authRepository);

  bool _isLoading = false;
  String? _errorMessage;
  AppUser? _authenticatedUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppUser? get authenticatedUser => _authenticatedUser;
  AppUser? get currentUser => _currentUser;

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.signInWithEmailAndPassword(email, password);

      if (_currentUser != null) {
        print('Login success. User role: ${_currentUser!.role}');
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = "Erro ao fazer login: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
