import 'package:flutter/material.dart';

class Favorite1 extends StatelessWidget {
  const Favorite1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello App'),
        ),
        body: const Center(
          child: Text(
            'Hello',
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}







