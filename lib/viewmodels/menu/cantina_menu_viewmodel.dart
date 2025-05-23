import 'package:flutter/material.dart';
import '../../models/menu_item.dart';
import '../../repositories/menu_repository.dart';

class CanteenMenuViewModel with ChangeNotifier {
  final MenuRepository _menuRepository;

  CanteenMenuViewModel(this._menuRepository);

  List<MenuItem> _menuItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MenuItem> get menuItems => _menuItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para carregar o cardápio da cantina
  Future<void> loadCanteenMenu() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _menuItems = await _menuRepository.getCanteenMenu();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage =
          'Erro ao carregar o cardápio da cantina.'; // Mensagem de erro genérica
      notifyListeners();
    }
  }
}
