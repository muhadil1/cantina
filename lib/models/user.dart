import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AppUser {
  final String? uid;
  final String email;
  final String apelido;
  final String role; // Campo crítico
  final String? establishmentId;
  final String? fcmToken;
  final Timestamp? createdAt;

  AppUser({
    this.uid,
    required this.email,
    required this.apelido,
    required this.role, // Garanta que é required
    this.establishmentId,
    this.fcmToken,
    this.createdAt,
  });

  // Factory method para criar um AppUser a partir de um objeto User do Firebase
  factory AppUser.fromFirebaseUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      apelido: '', // Valor temporário até atualizar no Firestore
      role: 'customer', // Valor padrão para novos usuários
    );
  }

  // Método de fábrica para criar AppUser a partir de DocumentSnapshot do Firestore
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      apelido: data['apelido'] ?? '',
      role: data['role'] ?? 'customer', // Valor padrão se não existir
      establishmentId: data['establishmentId'],
      fcmToken: data['fcmToken'],
      createdAt: data['createdAt'],
    );
  }
}
