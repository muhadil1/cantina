import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class Order {
  final String? id; // ID da encomenda (gerado pelo Firestore)
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final Timestamp timestamp;
  String status; // Ex: 'Pending', 'Processing', 'Ready', 'Delivered', 'Cancelled'

  Order({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
    this.status = 'Pending',
  });

  // Método para converter Order para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'timestamp': timestamp,
      'status': status,
    };
  }

  // Factory method para criar Order a partir de um DocumentSnapshot do Firestore
  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>?)
          ?.map((itemMap) => CartItem.fromMap(itemMap as Map<String, dynamic>))
          .toList() ??
          [],
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      timestamp: data['timestamp'] ?? Timestamp.now(),
      status: data['status'] ?? 'Pending',
    );
  }
}