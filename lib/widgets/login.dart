import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_authentication/firebase_auth.dart';

class MyLogin extends StatelessWidget {

  FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng nhập"),
        backgroundColor: Colors.deepPurpleAccent,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = await _auth.loginUserWithEmailAndPassword(
                    _emailController.text, _passwordController.text
                );

                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Đã đăng nhập thành công."),
                  ));

                  Navigator.of(context).popAndPushNamed("/content");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Có lỗi đăng nhập."),
                  ));
                }
              },
              child: Text(
                "Đăng nhập",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
