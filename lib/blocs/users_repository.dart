import 'package:firestore_link/value_objects/user.dart';

abstract class UsersRepository {
  Future<List<User>> getUsers();
  Future<void> editUser(User user);
  Future<void> deleteUser(User user);
}
