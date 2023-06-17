import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drb_app/models/LotLocations.dart';
import 'package:drb_app/models/Sequence.dart';
import 'package:flutter/material.dart';

class LotProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<LotLocation> _lots = [];

  List<Sequence> _seqs = [];

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

  addSeqs(List<Sequence> seqs) async {
    Map<String, dynamic> sMap = {};

    seqs.asMap().forEach((idx, seq) {
      sMap[idx.toString()] = seq.toJson();
    });
    //TODO generalize this
    await db
        .collection("Starter")
        .doc('LAMM')
        .set({}).onError((e, _) => print("Error writing document: $e"));

    print('complete');

    notifyListeners();
  }

  Future fetchSeqs(String loc) async {
    try {
      var doc = await db.collection('Starter').doc(loc).get();
      _seqs = [];

      doc.data()!.forEach((key, value) {
        _seqs.add(Sequence.fromMap(value));
      });

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<Sequence> get getSeqs {
    return _seqs;
  }
}
