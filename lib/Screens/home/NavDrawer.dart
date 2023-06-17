import 'package:drb_app/Screens/Auth/LoginPage.dart';
import 'package:drb_app/Screens/drawer/AddLocation.dart';
import 'package:drb_app/providers/LotProvider.dart';
import 'package:drb_app/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
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
            leading: Icon(Icons.folder),
            title: Text('Past Submissions'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Add Location'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLocation(),
                  ))
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Map'),
            onTap: () => {},
          ),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
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
