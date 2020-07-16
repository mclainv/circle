import 'package:firebase_database/firebase_database.dart';

class Balance {
  String _id;
  Balance(this._id);

  Balance.map(dynamic obj) {
    this._id = obj['id'];
  }

  String get id => _id;

  Balance.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
  }
}