import 'package:flutter/material.dart';

class Rate extends ChangeNotifier {
  int rate;
  int startNumber;
  int endNumber;
  int startCod;
  int endCod;
  int voids;
  int validations;
  int credits;
  List<int> shortTimes;
  List<String> attendants;
  int cash;
  int creditTotal;

  Rate({
    this.rate = 0,
    required this.startNumber,
    this.endNumber = 0,
    required this.startCod,
    this.endCod = 0,
    this.voids = 0,
    this.validations = 0,
    this.credits = 0,
    required List<int> shortTimes,
    required List<String> attendants,
    this.cash = 0,
    this.creditTotal = 0,
  })  : attendants = attendants ?? [],
        shortTimes = shortTimes ?? [];

  factory Rate.fromMap(Map data) {
    return Rate(
      rate: int.parse(data['rate']),
      startNumber: int.parse(data['startNumber']),
      endNumber: int.parse(data['endNumber']),
      startCod: int.parse(data['startCod']),
      endCod: int.parse(data['endCod']),
      voids: int.parse(data['voids']),
      validations: int.parse(data['validations']),
      credits: int.parse(data['credits']),
      shortTimes: data['shortTimes'].cast<int>(),
      attendants: data['attendants'].cast<String>(),
      cash: int.parse(data['cash']),
      creditTotal: int.parse(data['creditTotal']),
    );
  }

  Map<String, dynamic> toJson() => {
        'rate': rate,
        'startNumber': startNumber,
        'endNumber': endNumber,
        'startCod': startCod,
        'endCod': endCod,
        'voids': voids,
        'validations': validations,
        'credits': credits,
        'shortTimes': shortTimes,
        'attendants': attendants,
        'cash': cash,
        'creditTotal': creditTotal,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
