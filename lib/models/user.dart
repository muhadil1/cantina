import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String? uid;
  final String? email;

  AppUser({this.uid, this.email});

  // Factory method para criar um AppUser a partir de um objeto User do Firebase
  factory AppUser.fromFirebaseUser(User? firebaseUser) {
    return AppUser(
      uid: firebaseUser?.uid,
      email: firebaseUser?.email,
    );
  }

// Adicione outros campos relevantes do utilizador conforme necessário
}