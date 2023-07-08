import 'package:drb_app/Screens/Auth/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  String userName;
  ProfilePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final authServ = Provider.of<AuthService>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 32, top: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: userName,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: 'User',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                await authServ.signOut();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.exit_to_app),
              label: const Text("Logout"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
