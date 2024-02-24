import 'package:thedogs/testcode.dart';
import 'package:thedogs/widgets/settings.dart';
import '/widgets/homepage.dart';
import '/models/user_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
            "/settings": (context) => MySettings(),
            "/testcode": (context) => const MyApp2(),
          }),
    );
  }
}
