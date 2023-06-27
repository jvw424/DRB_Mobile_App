import 'package:drb_app/Screens/drb_route/LocationSelector.dart';
import 'package:drb_app/Screens/home/NavDrawer.dart';
import 'package:drb_app/providers/LotProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final lotProv = Provider.of<LotProvider>(context, listen: false);
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(title: const Text("DRB Home")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(300, 100)),
                  onPressed: () async {
                    lotProv.fetchLots();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocationSelctor(),
                        ));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.location_city),
                      Text(
                        'Select Location',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        width: 2.0,
                        color: Color.fromARGB(255, 83, 120, 139),
                      ),
                      fixedSize: const Size(300, 100),
                      backgroundColor: Colors.white),
                  onPressed: () async {
                    _determinePosition();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.location_searching,
                          size: 30, color: Color.fromARGB(255, 83, 120, 139)),
                      Text(
                        'Locate Me',
                        style: TextStyle(
                            fontSize: 22,
                            color: Color.fromARGB(255, 83, 120, 139)),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
