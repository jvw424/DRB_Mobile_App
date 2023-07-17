import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:drb_app/models/Activity.dart';
import 'package:drb_app/models/Rate.dart';
import 'package:drb_app/models/Sequence.dart';
import 'package:drb_app/models/SubmitInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class SubmitProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  SubmitInfo? _submission;
  final List<TableRow> _table = [];
  List<String> _lots = [];

  List<SubmitInfo> _drbs = [];
  List<bool> _selectedDrbs = [];
  List<String> _drbIds = [];

  String dir = '';
  String fileName = '';

  bool _stillSearching = true;
  List<Activity> acts = [];

  Future fetchInitialDrbs() async {
    try {
      _stillSearching = true;
      _drbs.clear();
      _selectedDrbs.clear();
      _drbIds.clear();
      notifyListeners();
      QuerySnapshot snap = await db
          .collection('Submissions')
          .orderBy('submitDate', descending: true)
          .limit(30)
          .get();

      for (var doc in snap.docs) {
        final res = SubmitInfo.fromMap(doc.data() as Map);
        _drbs.add(res);
        _selectedDrbs.add(false);
        _drbIds.add(doc.id);
      }

      if (_drbs.isEmpty) {
        _stillSearching = false;
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future searchInitial(String text) async {
    try {
      _stillSearching = true;
      _drbs.clear();
      _selectedDrbs.clear();
      _drbIds.clear();
      notifyListeners();

      QuerySnapshot snap = await db
          .collection('Submissions')
          .where('location', isEqualTo: text)
          .orderBy('submitDate', descending: true)
          .limit(80)
          .get();

      for (var doc in snap.docs) {
        final res = await SubmitInfo.fromMap(doc.data() as Map);
        _drbs.add(res);
        _selectedDrbs.add(false);
        _drbIds.add(doc.id);
      }
      if (_drbs.isEmpty) {
        _stillSearching = false;
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
      _stillSearching = true;
      _drbs.clear();
      _selectedDrbs.clear();
      _drbIds.clear();
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
        _selectedDrbs.add(false);
        _drbIds.add(doc.id);
      }
      if (_drbs.isEmpty) {
        _stillSearching = false;
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  drbTap(int idx) {
    _selectedDrbs[idx] = !_selectedDrbs[idx];
    notifyListeners();
  }

  drbDelete() async {
    String range = '';
    List<SubmitInfo> savedDrbs = [];

    for (var i = 0; i < _selectedDrbs.length; i++) {
      if (_selectedDrbs[i]) {
        savedDrbs.add(_drbs[i]);
      }
    }
    if (savedDrbs.length > 1) {
      range += savedDrbs.last.location;
      range += '_';
      range += DateFormat('M-d-yy').format(savedDrbs.last.submitDate!);
      range += '_';
      range += DateFormat('M-d-yy').format(savedDrbs.first.submitDate!);
    } else {
      range += savedDrbs.last.location;
      range += '_';
      range += DateFormat('M-d-yy').format(savedDrbs.first.submitDate!);
    }

    String sup = await getSupervisorName();

    Activity curAct = Activity(
        user: sup,
        activity: "Deleted submissions: $range",
        when: DateTime.now());

    await db
        .collection("Activity")
        .doc()
        .set(curAct.toJson())
        .onError((e, _) => print("Error writing document: $e"));

    for (var i = 0; i < _selectedDrbs.length; i++) {
      if (_selectedDrbs[i]) {
        await db.collection('Submissions').doc(_drbIds[i]).delete();
        _drbs.removeAt(i);
        _selectedDrbs.removeAt(i);
        _drbIds.removeAt(i);
      }
    }
    notifyListeners();
  }

  Future fetchInitialActs() async {
    try {
      _stillSearching = true;
      acts.clear();
      notifyListeners();
      QuerySnapshot snap = await db.collection('Activity').limit(60).get();

      for (var doc in snap.docs) {
        final res = Activity.fromMap(doc.data() as Map);
        acts.add(res);
      }

      if (acts.isEmpty) {
        _stillSearching = false;
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      } else {
        String? path = await getDownloadPath();
        return path;
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  makeCSV() async {
    List<List<dynamic>> csvList = [];

    List<SubmitInfo> savedDrbs = [];

    for (var i = 0; i < _selectedDrbs.length; i++) {
      if (_selectedDrbs[i]) {
        List<dynamic> header = [];
        List<dynamic> r1 = [];

        header.add('Date');
        header.add('Cash');
        header.add('Credit');
        header.add('Deposit');
        header.add('Over/Short');
        header.add('Bag #');
        header.add('Supervisor');
        header.add('Attendants');
        header.add('Shift Start');
        header.add('Shift End');
        header.add('CC Start');
        header.add('CC End');
        header.add('Notes');
        header.add('Cash Pickup');
        header.add('Pickup Supervisor');
        header.add('Location');

        r1.add(DateFormat('M/d/yy h:mm a').format(_drbs[i].submitDate!));
        r1.add(_drbs[i].cashTot!);
        r1.add(_drbs[i].credTot!);
        r1.add(_drbs[i].depositTotal!);
        r1.add(_drbs[i].overShort);
        r1.add(_drbs[i].bagNum!);
        r1.add(_drbs[i].supervisor!);
        r1.add(_drbs[i].attendants!);
        r1.add(_drbs[i].startTimes ?? null);
        r1.add(_drbs[i].endTimes ?? null);
        r1.add(_drbs[i].ccStart!);
        r1.add(_drbs[i].ccEnd!);
        r1.add(_drbs[i].notes ?? null);
        r1.add(_drbs[i].pickUpTotal ?? null);
        r1.add(_drbs[i].pickupSups ?? null);
        r1.add(_drbs[i].location);

        csvList.add(header);
        csvList.add(r1);
        savedDrbs.add(_drbs[i]);

        for (var seqs in _drbs[i].seqs) {
          for (var rate in seqs.rates) {
            if (rate == seqs.rates.first) {
              List<dynamic> rateHeader = [
                '',
              ];

              rateHeader.add('Cash');
              rateHeader.add('Credit');
              rateHeader.add('Rate');
              rateHeader.add('Start #');
              rateHeader.add('End #');
              rateHeader.add('# Credits');
              rateHeader.add('Start COD');
              rateHeader.add('End COD');
              rateHeader.add('Voids');
              rateHeader.add('Validations');
              rateHeader.add('Short Times');
              rateHeader.add('CC Short Times');

              csvList.add(rateHeader);
            }

            List<dynamic> rateRow = [
              '',
            ];
            rateRow.add(rate.cash);
            rateRow.add(rate.creditTotal);
            rateRow.add(rate.rate);
            rateRow.add(rate.startNumber);
            rateRow.add(rate.endNumber);
            rateRow.add(rate.credits);
            rateRow.add(rate.startCod);
            rateRow.add(rate.endCod);
            rateRow.add(rate.voids);
            rateRow.add(rate.validations);
            rateRow.add(rate.shortTimes);
            rateRow.add(rate.ccShortTimes);

            csvList.add(rateRow);
          }
        }
      }
    }
    String csv = const ListToCsvConverter().convert(csvList);

    String range = '';

    if (savedDrbs.length > 1) {
      range += DateFormat('M-d-yy').format(savedDrbs.last.submitDate!);
      range += '_';
      range += DateFormat('M-d-yy').format(savedDrbs.first.submitDate!);
    } else {
      range += DateFormat('M-d-yy').format(savedDrbs.first.submitDate!);
    }

    dir = (await getDownloadPath())!;
    fileName = '${savedDrbs[0].location}_$range.csv';

    final path = "${dir}/${savedDrbs[0].location}_$range.csv";

    await File('$path').create(recursive: true);
    final File file = File(path);
    await file.writeAsString(csv);

    for (var i = 0; i < _selectedDrbs.length; i++) {
      _selectedDrbs[i] = false;
    }
    notifyListeners();
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

  notesInput(String notes) {
    _submission!.notes = notes;
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

  bool get stillSearching {
    return _stillSearching;
  }

  String get getDir {
    return dir;
  }

  String get getFile {
    return fileName;
  }

  List<Activity> get getActs {
    return acts;
  }

  List<String> get getLots {
    return _lots;
  }

  List<SubmitInfo> get getDrbs {
    return _drbs;
  }

  List<bool> get getSelectedDrbs {
    return _selectedDrbs;
  }

  SubmitInfo? get getSubmit {
    return _submission;
  }

  List<TableRow> get getTable {
    return _table;
  }
}
