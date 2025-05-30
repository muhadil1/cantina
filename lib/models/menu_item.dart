import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  // Você pode adicionar mais campos conforme necessário, como ingredientes, etc.

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  // Factory method para criar um MenuItem a partir de um DocumentSnapshot do Firestore
  factory MenuItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuItem(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(), // Garantir que é double
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    // Assume que o map contém os campos necessários, incluindo 'id'
    return MenuItem(
      id: map['id'] ?? '', // Obter o ID do map
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // Método para converter MenuItem para um Map (Modificar para incluir o id)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // <<< Incluir o ID ao converter para map
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}
