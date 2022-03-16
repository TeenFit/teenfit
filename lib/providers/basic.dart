import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BasicCommands with ChangeNotifier {
  Future<bool> doesValueAlreadyExistFirestore(
    String documentName,
    String collection,
    String value,
  ) async {
    DocumentSnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection(collection)
        .doc(documentName)
        .get();

    final bool valueExists = result.get(value) != null;
    return valueExists;
  }

  Future<bool> doesDocumentExist(
    String documentName,
    String collection,
  ) async {
    final DocumentSnapshot result = await FirebaseFirestore.instance
        .collection(collection)
        .doc(documentName)
        .get();

    return result.exists;
  }
}
