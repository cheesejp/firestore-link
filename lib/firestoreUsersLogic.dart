import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUsersLogic {
  static const String _collectionId = "users";
  final _listController = StreamController<QuerySnapshot>();
  Stream<QuerySnapshot> get list => _listController.stream;

  FirestoreUsersLogic() {
    getUsers();
  }

  // Future<DocumentSnapshot> getUser(String userId, {int delayTime = 0}) async {
  //   await Future.delayed(Duration(seconds: delayTime));
  //   return Firestore.instance.collection(_collectionId).document(userId).get();
  // }

  void getUsers({int delayTime = 0}) async {
    await Future.delayed(Duration(seconds: delayTime));
    QuerySnapshot list =
        await Firestore.instance.collection(_collectionId).getDocuments();
    _listController.sink.add(list);
  }

  // Future<void> newRecord(String lastName, String name, {int delayTime = 0}) {
  //   Future.delayed(Duration(seconds: delayTime));
  //   return Firestore.instance.collection(_collectionId).add({
  //     'name': name,
  //     'last_name': lastName,
  //   });
  // }

  Future<void> newUser(String lastName, String name, {int delayTime = 0}) {
    Future.delayed(Duration(seconds: delayTime));
    return Firestore.instance.collection(_collectionId).document(name).setData({
      'name': name,
      'last_name': lastName,
    });
  }

  void dispose() {
    _listController.close();
  }
}
