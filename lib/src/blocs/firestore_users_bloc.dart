import 'dart:async';

import 'package:firestore_link/src/resources/models/user.dart';
import 'package:firestore_link/src/resources/repositories/firestore_users_repository.dart';

class FirestoreUsersBloc {
  final FirestoreUsersRepository _firestoreUsersRepository;
  final _listController = StreamController<List<User>>();
  Stream<List<User>> get listStream => _listController.stream;

  FirestoreUsersBloc(this._firestoreUsersRepository) {
    _firestoreUsersRepository.getUsers().then((list) {
      _listController.sink.add(list);
    });
  }

  void getUsers({int delayTime = 0}) async {
    List<User> list =
        await _firestoreUsersRepository.getUsers(delayTime: delayTime);
    _listController.sink.add(list);
  }

  Future<void> editUser(User user, {int delayTime = 0}) async {
    return _firestoreUsersRepository.editUser(user, delayTime: delayTime);
  }

  Future<void> deleteUser(User user, {int delayTime = 0}) async {
    return _firestoreUsersRepository.deleteUser(user, delayTime: delayTime);
  }

  void dispose() {
    _listController.close();
  }
}
