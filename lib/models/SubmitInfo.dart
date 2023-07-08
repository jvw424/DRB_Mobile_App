import 'package:drb_app/models/Sequence.dart';

class SubmitInfo {
  List<Sequence> seqs;
  String location;
  int lotNum;
  int? cashTot;
  int? credTot;
  int overShort;
  int? depositTotal;
  int? pickUpTotal;
  String? supervisor;
  String? bagNum;
  List<String?>? pickupSups;
  List<String?>? attendants;
  List<String?>? ccStart;
  List<String?>? ccEnd;
  List<String?>? startTimes;
  List<String?>? endTimes;
  String? notes;
  DateTime? submitDate;

  SubmitInfo({
    required this.seqs,
    required this.location,
    required this.lotNum,
    this.cashTot,
    this.credTot,
    this.ccStart,
    this.ccEnd,
    this.attendants,
    this.startTimes,
    this.endTimes,
    this.supervisor,
    this.pickUpTotal,
    this.pickupSups,
    this.overShort = 0,
    this.bagNum,
    this.depositTotal,
    this.submitDate,
    this.notes,
  });

  factory SubmitInfo.fromMap(Map data) {
    List<Sequence> fromMap = [];

    data['seqs'].forEach((key, value) {
      fromMap.add(Sequence.fromMap(value));
    });

    return SubmitInfo(
      seqs: fromMap,
      location: data['location'],
      lotNum: data['lotNum'],
      cashTot: data['cashTot'],
      credTot: data['credTot'],
      overShort: data['overShort'],
      depositTotal: data['depositTotal'],
      pickUpTotal: data['pickUpTotal'],
      supervisor: data['supervisor'],
      bagNum: data['bagNum'],
      pickupSups: data['pickupSups'].cast<String>(),
      attendants: data['attendants'].cast<String>(),
      ccStart: data['ccStart'].cast<String>(),
      ccEnd: data['ccEnd'].cast<String>(),
      startTimes: data['startTimes'].cast<String>(),
      endTimes: data['endTimes'].cast<String>(),
      submitDate: data['submitDate'].toDate(),
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rMap = {};
    Map<String, dynamic> sMap = {};

    seqs.asMap().forEach((idx, seq) {
      sMap[idx.toString()] = seq.toJson();
    });

    rMap['seqs'] = sMap;
    rMap['location'] = location;
    rMap['lotNum'] = lotNum;
    rMap['cashTot'] = cashTot;
    rMap['credTot'] = credTot;
    rMap['overShort'] = overShort;
    rMap['depositTotal'] = depositTotal;
    rMap['pickUpTotal'] = pickUpTotal;
    rMap['supervisor'] = supervisor;
    rMap['bagNum'] = bagNum;
    rMap['pickupSups'] = pickupSups;
    rMap['attendants'] = attendants;
    rMap['ccStart'] = ccStart;
    rMap['ccEnd'] = ccEnd;
    rMap['startTimes'] = startTimes;
    rMap['endTimes'] = endTimes;
    rMap['submitDate'] = submitDate;
    rMap['notes'] = notes;

    return rMap;
  }
}
