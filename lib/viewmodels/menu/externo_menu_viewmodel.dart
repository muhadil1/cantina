import 'package:flutter/material.dart';
import '../../models/menu_item.dart';
import '../../repositories/menu_repository.dart';

class ExternalMenuViewModel with ChangeNotifier {
  final MenuRepository _menuRepository;

  ExternalMenuViewModel(this._menuRepository);

  List<MenuItem> _menuItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MenuItem> get menuItems => _menuItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para carregar os cardápios externos
  Future<void> loadExternalMenus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _menuItems = await _menuRepository.getExternalMenus();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage =
          'Erro ao carregar os cardápios externos.'; // Mensagem de erro genérica
      notifyListeners();
    }
  }
}
