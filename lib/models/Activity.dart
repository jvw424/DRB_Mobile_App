import 'package:flutter/material.dart';

class Activity extends ChangeNotifier {
  final String user;
  final String activity;
  final DateTime when;

  Activity({
    required this.user,
    required this.activity,
    required this.when,
  });

  factory Activity.fromMap(Map data) {
    return Activity(
      user: data['user'],
      activity: data['activity'],
      when: data['when'].toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user,
        'activity': activity,
        'when': when,
      };
}
