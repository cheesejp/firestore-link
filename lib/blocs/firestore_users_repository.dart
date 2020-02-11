import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_link/blocs/users_repository.dart';
import 'package:firestore_link/value_objects/user.dart';

class FirestoreUsersRepository extends UsersRepository {
  static const String _collectionId = "users";

  Future<List<User>> getUsers({int delayTime = 0}) async {
    await Future.delayed(Duration(seconds: delayTime));
    QuerySnapshot _documents =
        await Firestore.instance.collection(_collectionId).getDocuments();
    List<User> _list = new List<User>();
    _documents.documents
        .forEach((v) => _list.add(User.fromDocumentSnapshot(v)));
    return _list;
  }

  Future<void> editUser(User user, {int delayTime = 0}) async {
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

  void deleteUserById(String documentId, {int delayTime = 0}) async {
    await Future.delayed(Duration(seconds: delayTime));
    return await Firestore.instance
        .collection(_collectionId)
        .document(documentId)
        .delete();
  }

  Future<void> deleteUser(User user, {int delayTime = 0}) async {
    return this.deleteUserById(user.documentId, delayTime: delayTime);
  }
}
