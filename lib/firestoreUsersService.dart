import 'package:cloud_firestore/cloud_firestore.dart';

enum UsersProperties { name, last_name }

class FirestoreUsersService {
  static const String _collectionId = "users";

  Future<DocumentSnapshot> getUser(String userId, {int delayTime = 0}) async {
    await Future.delayed(Duration(seconds: delayTime));
    return Firestore.instance.collection(_collectionId).document(userId).get();
  }

  Future<QuerySnapshot> getUsers({int delayTime = 0}) async {
    await Future.delayed(Duration(seconds: delayTime));
    return Firestore.instance.collection(_collectionId).getDocuments();
  }

  Future<void> newRecord(String lastName, String name, {int delayTime = 0}) {
    Future.delayed(Duration(seconds: delayTime));
    return Firestore.instance.collection(_collectionId).add({
      'name': name,
      'last_name': lastName,
    });
  }

  Future<void> newUser(String lastName, String name, {int delayTime = 0}) {
    Future.delayed(Duration(seconds: delayTime));
    return Firestore.instance.collection(_collectionId).document(name).setData({
      'name': name,
      'last_name': lastName,
    });
  }
}
