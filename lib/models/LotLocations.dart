import 'package:flutter/material.dart';

class LotLocation extends ChangeNotifier {
  final String name;
  final int number;
  //address info
  final int address;
  final String street;
  final String city;
  final String state;
  final int zip;
  //Latitude Longitude
  double lat;
  double long;

  LotLocation(
      {required this.name,
      required this.number,
      required this.address,
      required this.street,
      required this.city,
      required this.state,
      required this.zip,
      this.lat = 0.0,
      this.long = 0.0});

  factory LotLocation.fromMap(Map data) {
    return LotLocation(
      name: data['name'],
      number: data['number'],
      address: data['address'],
      street: data['street'],
      city: data['city'],
      state: data['state'],
      zip: data['zip'],
      lat: data['lat'],
      long: data['long'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'address': address,
        'street': street,
        'city': city,
        'state': state,
        'zip': zip,
        'lat': lat,
        'long': long,
      };
}
