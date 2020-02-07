import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String documentId;
  String name;
  String lastName;

  User({String id = '', String name = '', String lastName = ''}) {
    this.documentId = id;
    this.name = name;
    this.lastName = lastName;
  }

  User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.documentId = snapshot?.documentID ?? '';
    this.lastName = '';
    this.name = '';
    if (snapshot?.data != null) {
      this.lastName = snapshot?.data['last_name'] ?? '';
      this.name = snapshot?.data['name'] ?? '';
    }
  }
}
