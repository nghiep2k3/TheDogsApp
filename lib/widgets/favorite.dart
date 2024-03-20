import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

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







