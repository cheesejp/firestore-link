import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUsersBloc {
  static const String _collectionId = "users";
  final _listController = StreamController<QuerySnapshot>();
  Stream<QuerySnapshot> get list => _listController.stream;

  FirestoreUsersBloc() {
    getUsers();
  }

  void getUsers({int delayTime = 0}) async {
    await Future.delayed(Duration(seconds: delayTime));
    QuerySnapshot _list =
        await Firestore.instance.collection(_collectionId).getDocuments();
    _listController.sink.add(_list);
  }

  Future<void> newUser(String lastName, String name,
      {String documentId = '', int delayTime = 0}) {
    Future.delayed(Duration(seconds: delayTime));
    if (documentId.isEmpty) {
      return Firestore.instance.collection(_collectionId).add({
        'name': name,
        'last_name': lastName,
      });
    } else {
      return Firestore.instance
          .collection(_collectionId)
          .document(documentId)
          .setData({
        'name': name,
        'last_name': lastName,
      });
    }
  }

  Future<void> deleteUser(String documentId, {int delayTime = 0}) async {
    await Future.delayed(Duration(seconds: delayTime));
    return Firestore.instance
        .collection(_collectionId)
        .document(documentId)
        .delete();
  }

  void dispose() {
    _listController.close();
  }
}
