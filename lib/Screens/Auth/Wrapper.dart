import 'package:drb_app/Screens/Auth/LoginPage.dart';
import 'package:drb_app/Screens/drb_route/HomePage.dart';
import 'package:drb_app/Screens/Auth/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;

            return user == null ? const LoginPage() : const HomePage();
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
