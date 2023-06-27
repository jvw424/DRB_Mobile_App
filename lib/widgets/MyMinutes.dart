// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyMinutes extends StatelessWidget {
  int mins;

  MyMinutes({super.key, required this.mins});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            mins < 10 ? '0$mins' : mins.toString(),
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
