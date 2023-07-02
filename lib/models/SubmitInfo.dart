import 'package:drb_app/models/Sequence.dart';

class SubmitInfo {
  List<Sequence> seqs;
  String location;
  int? cashTot;
  int? credTot;
  int overShort;
  int? depositTotal;
  int? pickUpTotal;
  String? supervisor;
  String? bagNum;
  Set? pickupSups;
  Set? attendants;
  Set? ccStart;
  List<String?>? ccEnd;
  List<String?>? startTimes;
  List<String?>? endTimes;
  String? submitDate;

  SubmitInfo({
    required this.seqs,
    required this.location,
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
  });

  factory SubmitInfo.fromMap(Map data) {
    List<Sequence> fromMap = [];

    data['seqs'].forEach((key, value) {
      fromMap.add(Sequence.fromMap(value));
    });

    return SubmitInfo(
      seqs: fromMap,
      location: data['location'],
      cashTot: data['cashTot'],
      credTot: data['credTot'],
      overShort: data['overShort'],
      depositTotal: data['depositTotal'],
      pickUpTotal: data['pickUpTotal'],
      supervisor: data['supervisor'],
      bagNum: data['bagNum'],
      pickupSups: data['pickupSups'],
      attendants: data['attendants'],
      ccStart: data['ccStart'],
      ccEnd: data['ccEnd'],
      startTimes: data['startTimes'],
      endTimes: data['endTimes'],
      submitDate: data['submitDate'],
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

    return rMap;
  }
}
