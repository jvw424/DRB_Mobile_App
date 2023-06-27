// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AmPm extends StatelessWidget {
  final bool isItAm;

  const AmPm({super.key, required this.isItAm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            isItAm == true ? 'am' : 'pm',
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
