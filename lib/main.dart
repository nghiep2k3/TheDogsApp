import 'dart:io';
import 'package:thedogs/testcode.dart';
import 'package:thedogs/widgets/breed_detail.dart';
import 'package:thedogs/widgets/list_breeds.dart';
import 'package:thedogs/widgets/login.dart';
import 'package:thedogs/widgets/register.dart';
import 'package:thedogs/widgets/settings.dart';
import '/widgets/homepage.dart';
import '/models/user_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:firebase_core/firebase_core.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: 'AIzaSyCS_ZQEmoELru-nnwn6zBvNYvOl4aYkSBo',
              appId: '1:535748379503:android:dcff86b01d42e3d1bf9e9a',
              messagingSenderId: '535748379503',
              projectId: 'flutter-218e8'))
      : await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserInterface(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Nunito'),
          initialRoute: "/",
          routes: {
            "/": (context) => const MyHomePage(),
            "/register": (context) => MyRegister(),
            "/login": (context) => MyLogin(),
            "/settings": (context) => MySettings(),
            "/testcode": (context) => const MyApp2(),
            "/homepage": (context) => const MyHomePage(),
            "/list_breeds": (context) => const ListBreeds(),
            "/breed_detail": (context) => const BreedDetail(),
          }),
    );
  }
}
