import 'package:drb_app/Screens/Auth/AuthService.dart';
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
  void dispose() {
    // dispose the controllers so they don't display values on the login screen after logging out
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authServ = Provider.of<AuthService>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Perfect Parking Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 32, top: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .15,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.none,
                      image: AssetImage('assets/PP_logo.png'))),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailTextController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.visiblePassword,
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
