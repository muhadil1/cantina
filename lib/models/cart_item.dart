import 'menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;

  CartItem({required this.menuItem, this.quantity = 1});

  // Getters para facilitar o acesso
  String get id => menuItem.id;
  String get name => menuItem.name;
  double get price => menuItem.price;
  String get imageUrl => menuItem.imageUrl;
  double get totalPrice => price * quantity;

  // Método para converter CartItem para Map (útil para a encomenda)
  Map<String, dynamic> toMap() {
    return {
      'menuItem': menuItem.toMap(), // Inclui os detalhes do item do menu
      'quantity': quantity,
    };
  }

  // Factory method para criar CartItem a partir de Map (útil para histórico de encomendas)
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      menuItem: MenuItem.fromMap(map['menuItem'] as Map<String, dynamic>),
      quantity: map['quantity'] ?? 1,
    );
  }
}
