import 'package:drb_app/models/Rate.dart';

class Sequence {
  List<Rate> rates;
  int color;
  String startCredit;
  bool saved;

  Sequence({
    required this.rates,
    required this.startCredit,
    required this.color,
    this.saved = false,
  });

  factory Sequence.fromMap(Map data) {
    List<Rate> loaded = [];

    data.forEach((k2, v2) {
      if (k2 != 'color' && k2 != 'startCredit' && k2 != 'saved') {
        loaded.insert(int.parse(k2), Rate.fromMap(v2));
      }
    });

    return Sequence(
        startCredit: data['startCredit'],
        color: data['color'],
        rates: loaded,
        saved: data['saved']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rMap = {};
    rMap['startCredit'] = startCredit;
    rMap['color'] = color;
    rMap['saved'] = saved;
    rates.asMap().forEach((idx, rate) {
      rMap[idx.toString()] = rate.toJson();
    });
    return rMap;
  }

  @override
  String toString() {
    return rates.toString();
  }
}
