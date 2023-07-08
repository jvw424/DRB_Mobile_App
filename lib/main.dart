import 'package:drb_app/Screens/Auth/Wrapper.dart';
import 'package:drb_app/providers/AttendantProvider.dart';
import 'package:drb_app/providers/CheckProvider.dart';
import 'package:drb_app/providers/LotProvider.dart';
import 'package:drb_app/providers/SeqProvider.dart';
import 'package:drb_app/providers/SubmitProvider.dart';
import 'package:drb_app/Screens/Auth/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:drb_app/services/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<LotProvider>(create: (_) => LotProvider()),
        ChangeNotifierProvider<SeqProvider>(create: (_) => SeqProvider()),
        ChangeNotifierProvider<AttendantProvider>(
            create: (_) => AttendantProvider()),
        ChangeNotifierProvider<SubmitProvider>(create: (_) => SubmitProvider()),
        ChangeNotifierProvider<CheckProvider>(create: (_) => CheckProvider()),
      ],
      child: MaterialApp(
          title: 'Drb App',
          debugShowCheckedModeBanner: false,
          home: const Wrapper(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromARGB(255, 83, 120, 139),
            ),
          )),
    );
  }
}
