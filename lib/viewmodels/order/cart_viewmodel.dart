import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para obter o ID do utilizador
import 'package:cloud_firestore/cloud_firestore.dart'; // Para o Timestamp
import '../../models/cart_item.dart';
import '../../models/menu_item.dart';
import '../../models/order.dart' as pedido;
import '../../repositories/order_repository.dart';

class CartViewModel with ChangeNotifier {
  final OrderRepository _orderRepository;

  CartViewModel(this._orderRepository);

  List<CartItem> _items = [];
  bool _isPlacingOrder = false;
  String? _orderErrorMessage;

  List<CartItem> get items => _items;
  bool get isPlacingOrder => _isPlacingOrder;
  String? get orderErrorMessage => _orderErrorMessage;

  // Calcula o total do carrinho
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Adiciona um item ao carrinho ou aumenta a quantidade se já existir
  void addItem(MenuItem menuItem) {
    int existingIndex = _items.indexWhere((item) => item.menuItem.id == menuItem.id);

    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(menuItem: menuItem));
    }
    notifyListeners();
  }

  // Remove um item do carrinho ou diminui a quantidade
  void removeItem(MenuItem menuItem) {
    int existingIndex = _items.indexWhere((item) => item.menuItem.id == menuItem.id);

    if (existingIndex != -1) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
      } else {
        _items.removeAt(existingIndex); // Remove completamente se a quantidade for 1
      }
      notifyListeners();
    }
  }

  // Remove completamente um item do carrinho
  void removeAllOfItem(MenuItem menuItem) {
    _items.removeWhere((item) => item.menuItem.id == menuItem.id);
    notifyListeners();
  }


  // Limpa o carrinho
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Submete a encomenda
  Future<bool> placeOrder() async {
    if (_items.isEmpty) {
      _orderErrorMessage = "O carrinho está vazio.";
      notifyListeners();
      return false;
    }

    _isPlacingOrder = true;
    _orderErrorMessage = null;
    notifyListeners();

    try {
      // Obter o ID do utilizador autenticado
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        _orderErrorMessage = "Utilizador não autenticado.";
        _isPlacingOrder = false;
        notifyListeners();
        return false;
      }

      // Criar o objeto Order
      pedido.Order newOrder = pedido.Order(
        userId: userId,
        items: List.from(_items), // Cria uma cópia da lista de itens
        totalAmount: totalAmount,
        timestamp: Timestamp.now(),
        status: 'Pending', // Estado inicial
      );

      // Salvar a encomenda no repositório
      await _orderRepository.placeOrder(newOrder);

      // Limpar o carrinho após submeter a encomenda
      clearCart(); // Já notifica listeners

      _isPlacingOrder = false;
      // Não notifica listeners aqui pois clearCart já o fez e removemos o loading
      return true; // Encomenda submetida com sucesso
    } catch (e) {
      _isPlacingOrder = false;
      _orderErrorMessage = "Erro ao submeter a encomenda: $e"; // Mensagem de erro
      notifyListeners();
      return false; // Falha ao submeter a encomenda
    }
  }
}