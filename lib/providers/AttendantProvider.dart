import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendantProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> _attendants = [];
  List<String> selectedAtsList = [];

  addAttendant(String at) async {
    if (!_attendants.contains(at)) {
      _attendants.add(at);
      await db
          .collection("Attendants")
          .doc('names')
          .set({'names': _attendants}).onError(
              (e, _) => print("Error writing document: $e"));

      notifyListeners();
    }
  }

  Future fetchAts() async {
    var doc = await db.collection("Attendants").doc('names').get();
    _attendants = doc.data()!['names'].cast<String>();

    notifyListeners();
  }

  List<String> get getAts {
    return _attendants;
  }

// Selected Attendant related code

  removeSelecetedAts(idx) {
    selectedAtsList.removeAt(idx);
    notifyListeners();
  }

  addSelectedAts(String at) {
    selectedAtsList.insert(0, at);
    notifyListeners();
  }

  clearSelectedAts() {
    selectedAtsList.clear();
    notifyListeners();
  }

  List<String> get getSelectedAts {
    return selectedAtsList;
  }
}
