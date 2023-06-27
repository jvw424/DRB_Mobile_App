import 'package:drb_app/Screens/home/Wrapper.dart';
import 'package:drb_app/providers/AttendantProvider.dart';
import 'package:drb_app/providers/LotProvider.dart';
import 'package:drb_app/providers/SeqProvider.dart';
import 'package:drb_app/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:drb_app/firebase_options.dart';

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
    //   return StreamProvider<MyUser?>.value(
    //     catchError: (_, __) => null,
    //     initialData: null,
    //value: AuthService().myuser,
    // child: MaterialApp(
    //     title: 'Drb App',
    //     debugShowCheckedModeBanner: false,
    //     home: const Wrapper(),
    //     theme: ThemeData(
    //       colorScheme: ColorScheme.fromSwatch().copyWith(
    //         primary: const Color.fromARGB(255, 83, 120, 139),
    //       ),
    //     )),
    //   );
    // }
  }
}
