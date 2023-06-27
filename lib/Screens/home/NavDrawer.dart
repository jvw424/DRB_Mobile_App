import 'package:drb_app/Screens/drawer/AddLocation.dart';
import 'package:drb_app/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authServ = Provider.of<AuthService>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.none, image: AssetImage('assets/PP_logo.png'))),
            child: SizedBox.shrink(),
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Past Submissions'),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
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
            leading: const Icon(Icons.settings),
            title: const Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Map'),
            onTap: () => {},
          ),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () async {
                await authServ.signOut();
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => Wrapper()),
                //     (route) => false);
              }),
        ],
      ),
    );
  }
}
