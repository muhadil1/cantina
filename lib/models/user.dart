import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AppUser {
  final String? uid;
  final String? email;
  final String? role;
  final String? apelido; // <<< Adicionar este campo

  AppUser({this.uid, this.email, this.role, this.apelido});

  // Factory method para criar um AppUser a partir de um objeto User do Firebase
  factory AppUser.fromFirebaseUser(User? firebaseUser) {
    return AppUser(
      uid: firebaseUser?.uid,
      email: firebaseUser?.email,
      role: null, // Role é lido do Firestore
      apelido: null, // Apelido é lido do Firestore
    );
  }

  // Método de fábrica para criar AppUser a partir de DocumentSnapshot do Firestore
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return AppUser();

    return AppUser(
      uid: doc.id,
      email: data['email'] as String?,
      role: data['role'] as String? ?? 'customer',
      apelido: data['apelido'] as String?, // <<< Ler o campo 'apelido' do Firestore
    );
  }

  // Opcional: Adicione um método toMap() se precisar de converter AppUser para Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'apelido': apelido, // <<< Incluir no toMap
    };
  }
}
