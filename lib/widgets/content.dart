import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_authentication/firebase_auth.dart';

class MyContent extends StatelessWidget {
  FirebaseAuthService _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nội dung chính"),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).popAndPushNamed("/");
              },
              child: const Text(
                "Đăng xuất",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 20), // Khoảng cách giữa các nút
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/testcode");
              },
              child: const Text(
                "Test code",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/favorite");
              },
              child: const Text(
                "Test code",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
