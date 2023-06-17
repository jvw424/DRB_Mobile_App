import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drb_app/Screens/drb_route/LocationSelector.dart';
import 'package:drb_app/Screens/home/NavDrawer.dart';
import 'package:drb_app/models/LotLocations.dart';
import 'package:drb_app/models/Rate.dart';
import 'package:drb_app/models/Sequence.dart';
import 'package:drb_app/providers/LotProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  List<Sequence> sList = [
    Sequence(
        rates: [
          Rate(startNumber: 23001, startCod: 0, shortTimes: [], attendants: []),
          Rate(startNumber: 23005, startCod: 0, shortTimes: [], attendants: [])
        ],
        startCredit: DateFormat('h:mm a M/d/yy').format(DateTime.now()),
        color: 2),
    Sequence(
        rates: [
          Rate(startNumber: 32001, startCod: 0, shortTimes: [], attendants: [])
        ],
        startCredit: DateFormat('h:mm a M/d/yy').format(DateTime.now()),
        color: 4),
  ];

  // List<LotLocation> lots = [];

  // void setList() {
  //   lots = DatabaseService().getLocations() as List<LotLocation>;
  // }

  // void buttonHelp() {
  //   final client = Client()
  //       .setEndpoint('https://cloud.appwrite.io/v1')
  //       .setProject(appwriteId);
  //   final databases = Databases(client);

  //   locations.forEach((element) {
  //     try {
  //       final document = databases.createDocument(
  //           databaseId: appwriteDatabaseId,
  //           collectionId: collectionLoctions,
  //           documentId: ID.unique(),
  //           data: element);
  //     } on AppwriteException catch (e) {
  //       print(e);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final lotProv = Provider.of<LotProvider>(context);
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text("DRB Home")),
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
                        color: const Color.fromARGB(255, 83, 120, 139),
                      ),
                      fixedSize: const Size(300, 100),
                      backgroundColor: Colors.white),
                  onPressed: () async {
                    lotProv.fetchSeqs("Aliso");
                    print(lotProv.getSeqs);
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
