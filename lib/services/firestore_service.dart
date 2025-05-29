import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método genérico para obter documentos de uma coleção
  Future<QuerySnapshot> getCollection(String collectionPath) {
    return _firestore.collection(collectionPath).get();
  }

  // Método genérico para obter um documento específico de uma coleção
  Future<DocumentSnapshot> getDocument(
    String collectionPath,
    String documentId,
  ) {
    return _firestore.collection(collectionPath).doc(documentId).get();
  }

  // Método genérico para adicionar um documento a uma coleção
  Future<DocumentReference> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collectionPath).add(data);
  }

  // Método genérico para criar ou substituir um documento com um ID específico
  Future<void> setDocument(
      String collectionPath,
      String documentId,
      Map<String, dynamic> data,
      ) {
    return _firestore.collection(collectionPath).doc(documentId).set(data);
  }


  // Método genérico para atualizar um documento específico
  Future<void> updateDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collectionPath).doc(documentId).update(data);
  }

  // Método genérico para deletar um documento específico
  Future<void> deleteDocument(String collectionPath, String documentId) {
    return _firestore.collection(collectionPath).doc(documentId).delete();
  }

  // Você pode adicionar outros métodos específicos para queries mais complexas
}
