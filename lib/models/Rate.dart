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
  Map<int, int> shortTimes;
  List<String> attendants;
  String closeTimes;
  int pickup;
  int cash;
  int creditTotal;
  bool wasSaved;

  Rate({
    this.rate = 0,
    required this.startNumber,
    this.endNumber = 0,
    required this.startCod,
    this.endCod = 0,
    this.voids = 0,
    this.validations = 0,
    this.credits = 0,
    required Map<int, int> shortTimes,
    required List<String> attendants,
    this.cash = 0,
    this.creditTotal = 0,
    this.closeTimes = '',
    this.pickup = 0,
    this.wasSaved = false,
  })  : attendants = attendants ?? [],
        shortTimes = shortTimes ?? {};

  factory Rate.fromMap(Map data) {
    return Rate(
        rate: data['rate'],
        startNumber: data['startNumber'],
        endNumber: data['endNumber'],
        startCod: data['startCod'],
        endCod: data['endCod'],
        voids: data['voids'],
        validations: data['validations'],
        credits: data['credits'],
        shortTimes: data['shortTimes'].map<int, int>(
          (key, value) => MapEntry<int, int>(int.parse(key), int.parse(value)),
        ),
        attendants: data['attendants'].cast<String>(),
        cash: data['cash'],
        creditTotal: data['creditTotal'],
        closeTimes: data['closeTimes'],
        pickup: data['pickup'],
        wasSaved: data['wasSaved']);
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
        'closeTimes': closeTimes,
        'pickup': pickup,
        'wasSaved': wasSaved,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
