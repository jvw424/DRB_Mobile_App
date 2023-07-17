import 'package:drb_app/Screens/drawer/ActivityView.dart';
import 'package:drb_app/Screens/drawer/AddLocation.dart';
import 'package:drb_app/Screens/drawer/PastSubmissions.dart';
import 'package:drb_app/Screens/drawer/Profile.dart';
import 'package:drb_app/providers/SubmitProvider.dart';
import 'package:drb_app/Screens/Auth/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authServ = Provider.of<AuthService>(context);
    final subProv = Provider.of<SubmitProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage('assets/logo.png'))),
            child: SizedBox.shrink(),
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Past Submissions'),
            onTap: () async {
              subProv.fetchLots();
              subProv.fetchInitialDrbs();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PastSubmissions(),
                  ));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.plus),
            title: const Text('Add Location'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddLocation(),
                  ))
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.user),
            title: const Text('Profile'),
            onTap: () async {
              var user = await subProv.getSupervisorName();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      userName: user,
                    ),
                  ));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.clockRotateLeft),
            title: const Text('Activity'),
            onTap: () {
              subProv.fetchInitialActs();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityView(),
                  ));
            },
          ),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () async {
                await authServ.signOut();
              }),
        ],
      ),
    );
  }
}
