import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/content.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyContent();
        } else {
          return
            Scaffold(
              appBar: AppBar(
                title: Text("Trang chủ"),
                backgroundColor: Colors.blue,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).popAndPushNamed("/register"),
                      child: Text(
                        "Đăng ký",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),

                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                        foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).popAndPushNamed("/login"),
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                        foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
