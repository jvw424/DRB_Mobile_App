import 'package:drb_app/Screens/drb_route/LocationSelector.dart';
import 'package:drb_app/Screens/drawer/NavDrawer.dart';
import 'package:drb_app/providers/LotProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lotProv = Provider.of<LotProvider>(context, listen: false);
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(title: const Text("Home")),
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
                          builder: (context) => LocationSelctor(
                            isLocated: false,
                          ),
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
                  onPressed: () {
                    lotProv.locateLots();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LocationSelctor(isLocated: true),
                        ));
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
