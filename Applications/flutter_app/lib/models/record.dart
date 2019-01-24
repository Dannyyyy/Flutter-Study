import 'package:cloud_firestore/cloud_firestore.dart';

class Record {

  final String name;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> data, {this.reference}):
    assert(data['name'] != null),
    assert(data['votes'] != null),
    name = data['name'],
    votes = data['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot):
        this.fromMap(snapshot.data, reference: snapshot.reference);
}