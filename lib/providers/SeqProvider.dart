import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:drb_app/models/Activity.dart';
import 'package:drb_app/models/Rate.dart';
import 'package:drb_app/models/Sequence.dart';
import 'package:drb_app/services/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeqProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<Sequence> _seqs = [];
  List<int> _visitList = [];

  Future fetchSeqs(String loc) async {
    try {
      var doc = await db.collection('Starter').doc(loc).get();
      _seqs = [];

      doc.data()!.forEach((key, value) {
        _seqs.add(Sequence.fromMap(value));
      });
    } catch (e) {}
  }

  Future<String> getSupervisorName() async {
    String uid = _firebaseAuth.currentUser!.uid;
    var doc = await db.collection("Users").doc(uid).get();
    return doc.data()!['Name'];
  }

  addSeqs({required Sequence seq, required String loc}) async {
    _seqs.add(seq);

    Map<String, dynamic> sMap = {};
    _seqs.asMap().forEach((idx, seq) {
      sMap[idx.toString()] = seq.toJson();
    });

    await db
        .collection("Starter")
        .doc(loc)
        .set(sMap)
        .onError((e, _) => print("Error writing document: $e"));

    notifyListeners();

    String sup = await getSupervisorName();

    Activity curAct = Activity(
        user: sup,
        activity:
            "$loc new Sequence Start #${seq.rates.last.startNumber} Color: ${colTranslate[seq.color.toString()]}",
        when: DateTime.now());

    await db
        .collection("Activity")
        .doc()
        .set(curAct.toJson())
        .onError((e, _) => print("Error writing document: $e"));
  }

  deleteSeqs(int idx, String loc) async {
    Sequence seq = _seqs.removeAt(idx);

    Map<String, dynamic> sMap = {};

    _seqs.asMap().forEach((idx, seq) {
      sMap[idx.toString()] = seq.toJson();
    });
    await db
        .collection("Starter")
        .doc(loc)
        .set(sMap)
        .onError((e, _) => print("Error writing document: $e"));

    notifyListeners();

    String sup = await getSupervisorName();

    Activity curAct = Activity(
        user: sup,
        activity:
            "$loc deleted Sequence #${seq.rates.last.startNumber} Color: ${colTranslate[seq.color.toString()]}",
        when: DateTime.now());

    await db
        .collection("Activity")
        .doc()
        .set(curAct.toJson())
        .onError((e, _) => print("Error writing document: $e"));
  }

  ///
  ///Rate Level Changes
  ///

  addRate(int idx, List<String> ats) {
    int endNum = _seqs[idx].rates.last.endNumber;
    int endCod = _seqs[idx].rates.last.endCod;
    int endRate = _seqs[idx].rates.last.rate;

    _seqs[idx].rates.add(Rate(
        startNumber: endNum,
        endNumber: endNum,
        rate: endRate,
        startCod: endCod,
        endCod: endCod,
        shortTimes: {},
        ccShortTimes: {},
        attendants: ats));

    notifyListeners();
  }

  deleteRate(int idx) {
    _seqs[idx].rates.removeLast();
    notifyListeners();
  }

  applyChanges(int idx) {
    Rate curRate = _seqs[idx].rates.last;
    if (curRate.endNumber == 0 || curRate.rate == 0) {
      return;
    }
    int numShortTics = 0;
    int shortTimeValue = 0;

    curRate.shortTimes.forEach((price, quant) {
      shortTimeValue += int.parse(price) * quant;
      numShortTics += quant;
    });

    int numccShortTics = 0;
    int ccshortTimeValue = 0;

    curRate.ccShortTimes.forEach((price, quant) {
      ccshortTimeValue += int.parse(price) * quant;
      numccShortTics += quant;
    });

    int ticTotal = curRate.endNumber -
        curRate.startNumber +
        curRate.startCod -
        curRate.endCod -
        curRate.voids -
        curRate.validations -
        curRate.credits -
        numShortTics;

    curRate.cash = curRate.rate * ticTotal + shortTimeValue;

    curRate.creditTotal =
        curRate.rate * (curRate.credits - numccShortTics) + ccshortTimeValue;
  }

  bool validCheck(int idx) {
    Rate curRate = _seqs[idx].rates.last;

    if (curRate.endNumber - curRate.startNumber <= 0) {
      return false;
    }
    if ((curRate.endNumber - curRate.startNumber) -
            (curRate.voids +
                curRate.credits +
                curRate.validations +
                (curRate.endCod - curRate.startCod)) <=
        0) {
      return false;
    }
    return true;
  }

  void editRate(int value, int idx) {
    _seqs[idx].rates.last.rate = value;
    applyChanges(idx);
    notifyListeners();
  }

  void editEndNum(int value, int idx) {
    _seqs[idx].rates.last.endNumber = value;
    applyChanges(idx);
    notifyListeners();
  }

  void editEndCod(int value, int idx) {
    _seqs[idx].rates.last.endCod = value;
    applyChanges(idx);
    notifyListeners();
  }

  void editCredits(int value, int idx) {
    _seqs[idx].rates.last.credits = value;
    applyChanges(idx);
    notifyListeners();
  }

  void editVoids(int value, int idx) {
    _seqs[idx].rates.last.voids = value;
    applyChanges(idx);
    notifyListeners();
  }

  void editValidations(int value, int idx) {
    _seqs[idx].rates.last.validations = value;
    applyChanges(idx);
    notifyListeners();
  }

  addShortTime(
      {required bool isCC,
      required int val,
      required int quant,
      required int idx}) {
    print(isCC);
    if (isCC) {
      _seqs[idx].rates.last.ccShortTimes[val.toString()] = quant;
    } else {
      _seqs[idx].rates.last.shortTimes[val.toString()] = quant;
    }

    applyChanges(idx);
    notifyListeners();
  }

  clearShortTime(int idx) {
    _seqs[idx].rates.last.shortTimes.clear();
    _seqs[idx].rates.last.ccShortTimes.clear();
    applyChanges(idx);
    notifyListeners();
  }

  addAt(List<String> atList, int idx) {
    _seqs[idx].rates.last.attendants = atList;
    notifyListeners();
  }

  setSaved(int idx, bool isSaved) {
    _seqs[idx].saved = isSaved;
  }

  cashPickup(int pickup, String supervisor) {
    for (var seq in _seqs) {
      if (seq.saved) {
        seq.rates.last.pickup = pickup;
        seq.rates.last.supervisor = supervisor;
      }
    }

    notifyListeners();
  }

  makeCloseTimes(
    IterableZip<dynamic> times,
  ) {
    for (final pair in times) {
      for (var seq in _seqs) {
        if (pair[0] == seq.startCredit) {
          seq.rates.last.closeTimes =
              '${seq.startCredit} - ${DateFormat('h:mm a M/d/yy').format(pair[1])}';
          seq.startCredit = DateFormat('h:mm a M/d/yy').format(pair[1]);
        }
      }
    }
  }

  saveButton(String loc) async {
    for (var seq in _seqs) {
      if (seq.saved) {
        seq.rates.last.wasSaved = true;
      }
    }

    Map<String, dynamic> sMap = {};
    _seqs.asMap().forEach((idx, seq) {
      sMap[idx.toString()] = seq.toJson();
    });

    await db
        .collection("Starter")
        .doc(loc)
        .set(sMap)
        .onError((e, _) => print("Error writing document: $e"));

    notifyListeners();
  }

  makeVisitList() {
    _visitList.clear();
    for (var i = 0; i < _seqs.length; i++) {
      {
        if (_seqs[i].saved) {
          _visitList.add(i);
        }
      }
    }
  }

  addToVisited(int idx) {
    _visitList.add(idx);
    notifyListeners();
  }

  int popVisited() {
    int idx = _visitList.removeLast();
    notifyListeners();
    return idx;
  }

  List<int> get getVisited {
    return _visitList;
  }

  List<Sequence> get getSeqs {
    return _seqs;
  }

  int get getLastIdx {
    return _seqs.length - 1;
  }
}
