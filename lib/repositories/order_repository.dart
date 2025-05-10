import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as pedido;
import '../services/firestore_service.dart';

class OrderRepository {
  final FirestoreService _firestoreService;
  final String _ordersCollection = 'orders'; // Coleção para armazenar encomendas

  OrderRepository(this._firestoreService);

  // Método para submeter uma nova encomenda
  Future<void> placeOrder(pedido.Order order) async {
    try {
      await _firestoreService.addDocument(_ordersCollection, order.toMap());
      print('Encomenda submetida com sucesso!');
    } catch (e) {
      print('Erro ao submeter encomenda: $e');
      rethrow; // Relançar para ser tratado pelo ViewModel
    }
  }

  // Método para obter o histórico de encomendas de um utilizador (opcional para este passo)
  Future<List<pedido.Order>> getUserOrders(String userId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance // Usando instância direta para query complexa
          .collection(_ordersCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true) // Ordenar por data
          .get();
      return snapshot.docs.map((doc) => pedido.Order.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching user orders: $e');
      rethrow;
    }
  }

  // Método para observar o estado de uma encomenda específica (útil para notificações)
  Stream<pedido.Order> getOrderStream(String orderId) {
    return FirebaseFirestore.instance
        .collection(_ordersCollection)
        .doc(orderId)
        .snapshots()
        .map((doc) => pedido.Order.fromFirestore(doc));
  }
}