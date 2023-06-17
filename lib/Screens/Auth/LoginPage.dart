import 'package:drb_app/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final authServ = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfect Parking Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailTextController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.phone,
                controller: passwordTextController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: false,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  await authServ.signIn(emailTextController.text.trim(),
                      passwordTextController.text.trim());
                },
                icon: const Icon(Icons.login),
                label: const Text("Sign in"),
              ),

              // ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const MessagesPage()));
              //   },
              //   child: const Text('Read Messages as Guest'),
              // ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
