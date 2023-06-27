// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyHours extends StatelessWidget {
  int hours;

  MyHours({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            hours.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
