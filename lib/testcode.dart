import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thedogs/models/user_interface.dart';


class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  


  @override
  Widget build(BuildContext context) {
    return Consumer<UserInterface>(
      builder: (context, ui, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Nhà phát triển'),
            centerTitle: true,
            backgroundColor: ui.appBarColor,
          ),
        );
      }
    );
  }
}
