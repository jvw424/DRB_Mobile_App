import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<SubmitInfo> _drbs = [];

  Future fetchDrbs() async {
    try {
      QuerySnapshot snap = await db.collection('Submissions').get();
      _drbs = [];

      for (var doc in snap.docs) {
        final res = SubmitInfo.fromMap(doc.data() as Map);
        _drbs.add(res);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  setInfo(List<Sequence> seqs, String location) async {
    int credTot = 0;
    int cashTot = 0;
    int pickupTot = 0;
    Set ats = {};
    Set ccStart = {};

    Set pickupSup = {};
    List<String?> ccEnd = [];

    List<String?> startTimes = [];
    List<String?> endTimes = [];

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
      }
    }

    for (var seq in seqs) {
      if (seq.rates.last.closeTimes != '') {
        continue;
      } else {
        for (var rate in seq.rates) {
          if (rate.credits != 0) {
            ccStart.add(seq.startCredit);
            print('add');
            print(ccStart);
          }
          if (rate.closeTimes != '') {
            ccStart.remove(seq.startCredit);
            print('remove');
            print(ccStart);
          }
        }
      }
    }

    for (var i = 0; i < ccStart.length; i++) {
      ccEnd.add('null');
    }
    for (var i = 0; i < ats.length; i++) {
      endTimes.add('null');
      startTimes.add('null');
    }

    _submission = SubmitInfo(
      seqs: seqs,
      location: location,
      cashTot: cashTot,
      credTot: credTot,
      supervisor: supervisor,
      attendants: ats,
      ccStart: ccStart,
      ccEnd: ccEnd,
      startTimes: startTimes,
      endTimes: endTimes,
      pickUpTotal: pickupTot,
      pickupSups: pickupSup,
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
      for (var rate in seq.rates) {
        int numShortTics = 0;

        rate.shortTimes.forEach((price, quant) {
          numShortTics += quant;
        });

        int ticTotal = rate.endNumber -
            rate.startNumber +
            rate.startCod -
            rate.endCod -
            rate.voids -
            rate.validations -
            rate.credits -
            numShortTics;

        int cashTot = ticTotal * rate.rate;

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
          child: Text('\$$cashTot',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
              )),
        ));
        row.add(Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Text('${rate.credits}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
              )),
        ));
        row.add(Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Text('\$${rate.creditTotal}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
              )),
        ));

        _table.add(TableRow(children: row));

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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text('',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ]));
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

  submitDrb() async {
    _submission!.submitDate =
        DateFormat('h:mm a M/d/yy').format(DateTime.now());

    Map<String, dynamic> sMap = _submission!.toJson();

    await db
        .collection("Submissions")
        .doc()
        .set(sMap)
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
