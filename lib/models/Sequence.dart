import 'package:drb_app/models/Rate.dart';
import 'package:intl/intl.dart';

class Sequence {
  List<Rate> rates;
  int color;
  String startCredit;

  Sequence({
    required this.rates,
    required this.startCredit,
    required this.color,
  });

  factory Sequence.fromMap(Map data) {
    List<Rate> loaded = [];

    data.forEach((k2, v2) {
      if (k2 != 'color' && k2 != 'startCredit') {
        loaded.insert(int.parse(k2), Rate.fromMap(v2));
      }
    });

    return Sequence(
      startCredit: data['startCredit'],
      color: int.parse(data['color']),
      rates: loaded,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rMap = {};
    rMap['startCredit'] =
        DateFormat('h:mm a M/d/yy').format(DateTime.parse(startCredit));
    rMap['color'] = color;
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
