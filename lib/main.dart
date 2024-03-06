import 'package:thedogs/testcode.dart';
import 'package:thedogs/widgets/settings.dart';
import '/widgets/homepage.dart';
import '/models/user_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './widgets/Action/Search.dart';
import './widgets/Action/InfoDogs.dart';


main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserInterface(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: "/",
          routes: {
            "/": (context) => const MyHomePage(),
            "/search": (context) => Muonsach(),
            "/infodogs": (context) => InfoDogs(),
            "/settings": (context) => MySettings(),
            "/testcode": (context) => const MyApp2(),
          }),
    );
  }
}
