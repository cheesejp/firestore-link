import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_link/value_objects/user.dart';

class FirestoreUsersBloc {
  static const String _collectionId = "users";
  final _listController = StreamController<List<User>>();
  Stream<List<User>> get listStream => _listController.stream;

  FirestoreUsersBloc() {
    getUsers();
  }

  void getUsers({int delayTime = 0}) async {
    await Future.delayed(Duration(seconds: delayTime));
    QuerySnapshot _documents =
        await Firestore.instance.collection(_collectionId).getDocuments();
    List<User> _list = new List<User>();
    _documents.documents
        .forEach((v) => _list.add(User.fromDocumentSnapshot(v)));
    _listController.sink.add(_list);
  }

  Future<void> newUser(User user, {int delayTime = 0}) {
    Future.delayed(Duration(seconds: delayTime));
    if (user.documentId.isEmpty) {
      return Firestore.instance.collection(_collectionId).add({
        'name': user.name,
        'last_name': user.lastName,
      });
    } else {
      return Firestore.instance
          .collection(_collectionId)
          .document(user.documentId)
          .setData({
        'name': user.name,
        'last_name': user.lastName,
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
