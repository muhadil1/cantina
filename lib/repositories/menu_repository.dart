import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';
import '../services/firestore_service.dart';

class MenuRepository {
  final FirestoreService _firestoreService;

  MenuRepository(this._firestoreService);

  // Coleções no Firestore (assumindo que você terá coleções separadas ou uma com um campo 'source')
  final String _canteenMenuCollection = 'canteen_menu';
  final String _externalMenuCollection =
      'external_menus'; // Exemplo: pode ser uma coleção de estabelecimentos

  // Método para obter o cardápio da cantina
  Future<List<MenuItem>> getCanteenMenu() async {
    try {
      QuerySnapshot snapshot = await _firestoreService.getCollection(
        _canteenMenuCollection,
      );
      return snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching canteen menu: $e');
      rethrow; // Relançar para ser tratado pelo ViewModel
    }
  }

  // Método para obter cardápios de estabelecimentos externos
  // Por enquanto, vamos buscar todos os itens de uma coleção 'external_menus'.
  // Em uma implementação real, você pode querer filtrar por estabelecimento.
  Future<List<MenuItem>> getExternalMenus() async {
    try {
      QuerySnapshot snapshot = await _firestoreService.getCollection(
        _externalMenuCollection,
      );
      return snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching external menus: $e');
      rethrow; // Relançar para ser tratado pelo ViewModel
    }
  }

  // Você pode adicionar métodos para obter menus de um estabelecimento específico, etc.
}
