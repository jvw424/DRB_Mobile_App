import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drb_app/models/LotLocations.dart';
import 'package:flutter/material.dart';

class LotProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<LotLocation> _lots = [];

  Future fetchLots() async {
    try {
      QuerySnapshot snap = await db.collection('Locations').get();
      _lots = [];

      for (var doc in snap.docs) {
        final res = LotLocation.fromMap(doc.data() as Map);
        _lots.add(res);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  addLocation(LotLocation lot) async {
    await db
        .collection("Locations")
        .doc(lot.name)
        .set(lot.toJson())
        .onError((e, _) => print("Error writing document: $e"));

    notifyListeners();
  }

  List<LotLocation> get getlots {
    return _lots;
  }

  void notify() {
    notifyListeners();
  }
}
