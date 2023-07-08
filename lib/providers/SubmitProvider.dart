import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drb_app/models/LotLocations.dart';
import 'package:drb_app/models/Rate.dart';
import 'package:drb_app/models/Sequence.dart';
import 'package:drb_app/models/SubmitInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubmitProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  SubmitInfo? _submission;
  final List<TableRow> _table = [];
  List<String> _lots = [];

  List<SubmitInfo> _drbs = [];

  Future fetchInitialDrbs() async {
    try {
      _drbs = [];
      notifyListeners();
      QuerySnapshot snap = await db
          .collection('Submissions')
          .orderBy('submitDate', descending: true)
          .limit(30)
          .get();

      for (var doc in snap.docs) {
        final res = SubmitInfo.fromMap(doc.data() as Map);
        _drbs.add(res);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future searchInitial(String text) async {
    try {
      _drbs = [];
      notifyListeners();

      QuerySnapshot snap = await db
          .collection('Submissions')
          .where('location', isEqualTo: text)
          .orderBy('submitDate', descending: true)
          .limit(30)
          .get();

      for (var doc in snap.docs) {
        final res = await SubmitInfo.fromMap(doc.data() as Map);
        _drbs.add(res);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future queryInitial(
    String text,
    DateTime d1,
    DateTime d2,
  ) async {
    try {
      _drbs = [];
      notifyListeners();

      QuerySnapshot snap = await db
          .collection('Submissions')
          .where('location', isEqualTo: text)
          .where("submitDate",
              isGreaterThanOrEqualTo: d1, isLessThanOrEqualTo: d2)
          .orderBy('submitDate', descending: true)
          .get();

      for (var doc in snap.docs) {
        final res = await SubmitInfo.fromMap(doc.data() as Map);
        _drbs.add(res);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future fetchLots() async {
    try {
      QuerySnapshot snap = await db.collection('Locations').get();
      _lots = [];

      for (var doc in snap.docs) {
        _lots.add(doc.id);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  setInfo(List<Sequence> seqs, String location, int lotNum) async {
    int credTot = 0;
    int cashTot = 0;
    int pickupTot = 0;
    Set ats = {};
    Set ccStart = {};

    Set pickupSup = {};
    List<String?> ccEnd = [];

    List<String?> startTimes = [];
    List<String?> endTimes = [];

    List<String?>? listAts = [];
    List<String?>? listccStart = [];
    List<String?>? listPickupSups = [];

    String uid = _firebaseAuth.currentUser!.uid;
    var doc = await db.collection("Users").doc(uid).get();
    var supervisor = doc.data()!['Name'];

    for (var seq in seqs) {
      if (seq.saved) {
        for (var rate in seq.rates) {
          cashTot += rate.cash;
          credTot += rate.creditTotal;
          cashTot -= rate.pickup;
          pickupTot += rate.pickup;

          if (rate.supervisor != '') {
            pickupSup.add(supervisor);
          }

          for (var at in rate.attendants) {
            ats.add(at);
          }
        }

        if (seq.rates.last.closeTimes != '') {
          continue;
        } else {
          for (var rate in seq.rates) {
            if (rate.credits != 0) {
              ccStart.add(seq.startCredit);
            }
            if (rate.closeTimes != '') {
              ccStart.remove(seq.startCredit);
            }
          }
        }
      }
    }

    for (var i = 0; i < ccStart.length; i++) {
      ccEnd.add('null');
      listccStart.add(ccStart.elementAt(i));
    }
    for (var i = 0; i < ats.length; i++) {
      endTimes.add('null');
      startTimes.add('null');
      listAts.add(ats.elementAt(i));
    }
    for (var i = 0; i < pickupSup.length; i++) {
      listPickupSups.add(pickupSup.elementAt(i));
    }

    _submission = SubmitInfo(
      seqs: seqs,
      location: location,
      lotNum: lotNum,
      cashTot: cashTot,
      credTot: credTot,
      supervisor: supervisor,
      attendants: listAts,
      ccStart: listccStart,
      ccEnd: ccEnd,
      startTimes: startTimes,
      endTimes: endTimes,
      pickUpTotal: pickupTot,
      pickupSups: listPickupSups,
    );
  }

  makeTable() {
    _table.clear();

    _table.add(TableRow(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
        ),
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text("\nRate",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text("Cash\nTickets",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text('Cash\nAmount',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text("CC\nTickets",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text('CC\nAmount',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ]));

    for (var seq in _submission!.seqs) {
      if (seq.saved) {
        for (var rate in seq.rates) {
          int numShortTics = 0;
          int numccShortTics = 0;

          rate.shortTimes.forEach((price, quant) {
            numShortTics += quant;
          });

          rate.ccShortTimes.forEach((price, quant) {
            numccShortTics += quant;
          });

          int ticTotal = rate.endNumber -
              rate.startNumber +
              rate.startCod -
              rate.endCod -
              rate.voids -
              rate.validations -
              rate.credits -
              numShortTics;

          int credTics = rate.credits - numccShortTics;

          List<Widget> row = [];

          row.add(Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text('\$${rate.rate.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                )),
          ));
          row.add(Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text('$ticTotal',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                )),
          ));
          row.add(Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text('\$${rate.rate * ticTotal}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                )),
          ));
          row.add(Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text('$credTics',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                )),
          ));
          row.add(Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text('\$${credTics * rate.rate}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                )),
          ));

          _table.add(TableRow(children: row));

          rate.ccShortTimes.forEach((price, quant) {
            int cTot = int.parse(price) * quant;
            List<Widget> cRow = [];

            cRow.add(Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('\$${price.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                  )),
            ));
            cRow.add(Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('0',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                  )),
            ));
            cRow.add(const Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('\$0',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                  )),
            ));
            cRow.add(Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('$quant',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                  )),
            ));
            cRow.add(Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('\$$cTot',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                  )),
            ));

            _table.add(TableRow(children: cRow));
          });

          rate.shortTimes.forEach((price, quant) {
            int tot = int.parse(price) * quant;
            List<Widget> sRow = [];

            sRow.add(Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('\$${price.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                  )),
            ));
            sRow.add(Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('$quant',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                  )),
            ));
            sRow.add(Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('\$$tot',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                  )),
            ));
            sRow.add(const Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                  )),
            ));
            sRow.add(const Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('\$0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                  )),
            ));

            _table.add(TableRow(children: sRow));
          });

          if (rate.pickup != 0) {
            String sups = '';

            var arr = rate.supervisor.split(' ');
            sups += (arr[0]);

            _table.add(TableRow(children: [
              const Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Text("Pickup",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Text("$sups",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.red)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Text('-\$${rate.pickup}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    )),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Text("",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Text('',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ]));
          }
        }
      }
    }

    _table.add(TableRow(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
        ),
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text("Total",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text("",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text('\$${_submission!.cashTot}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text("",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text('\$${_submission!.credTot}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ]));
  }

  viewSubmission(SubmitInfo submission) async {
    _submission = submission;
    await makeTable();
  }

  submitDrb() async {
    _submission!.submitDate = DateTime.now();

    List<Sequence> all = List.from(_submission!.seqs);

    List<Sequence> operatedOn = [];

    for (var seq in _submission!.seqs) {
      if (seq.saved) {
        operatedOn.add(seq);
      }
    }

    _submission!.seqs = operatedOn;

    Map<String, dynamic> sMap = _submission!.toJson();

    await db
        .collection("Submissions")
        .doc()
        .set(sMap)
        .onError((e, _) => print("Error writing document: $e"));

    Map<String, dynamic> nMap = {};
    for (Sequence seq in all) {
      if (seq.saved) {
        int endNum = seq.rates.last.endNumber;
        int endCod = seq.rates.last.endCod;
        int endRate = seq.rates.last.rate;

        seq.rates.clear();

        seq.rates.add(Rate(
            startNumber: endNum,
            endNumber: endNum,
            rate: endRate,
            startCod: endCod,
            endCod: endCod,
            shortTimes: {},
            ccShortTimes: {},
            attendants: []));
        seq.saved = false;
      }
      for (var i = 0; i < _submission!.ccStart!.length; i++) {
        if (_submission!.ccStart![i] == seq.startCredit) {
          seq.startCredit = _submission!.ccEnd![i]!;
        }
      }
    }

    all.asMap().forEach((idx, seq) {
      nMap[idx.toString()] = seq.toJson();
    });

    await db
        .collection("Starter")
        .doc(_submission!.location)
        .set(nMap)
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<String> getSupervisorName() async {
    String uid = _firebaseAuth.currentUser!.uid;
    var doc = await db.collection("Users").doc(uid).get();
    return doc.data()!['Name'];
  }

  depositInput(String val) {
    if (int.tryParse(val) != null || int.tryParse(val)! >= 0) {
      _submission!.overShort = int.parse(val) - _submission!.cashTot!;
      _submission!.depositTotal = int.parse(val);
      notifyListeners();
    } else {
      _submission!.overShort = 0 - _submission!.cashTot!;
      notifyListeners();
    }
  }

  bagInput(String bagNum) {
    _submission!.bagNum = bagNum;
  }

  startTimeInput(DateTime sTime, int idx) {
    _submission!.startTimes![idx] = DateFormat('h:mm a M/d/yy').format(sTime);
    notifyListeners();
  }

  endTimeInput(DateTime sTime, int idx) {
    _submission!.endTimes![idx] = DateFormat('h:mm a M/d/yy').format(sTime);
    notifyListeners();
  }

  ccEndInput(DateTime sTime, int idx) {
    _submission!.ccEnd![idx] = DateFormat('h:mm a M/d/yy').format(sTime);
    notifyListeners();
  }

  List<String> get getLots {
    return _lots;
  }

  List<SubmitInfo> get getDrbs {
    return _drbs;
  }

  SubmitInfo? get getSubmit {
    return _submission;
  }

  List<TableRow> get getTable {
    return _table;
  }
}
