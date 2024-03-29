// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_authentication/firebase_auth.dart';

// MyLogin là một StatefulWidget để có thể quản lý trạng thái
class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

// _MyLoginState quản lý trạng thái của MyLogin Widget
class _MyLoginState extends State<MyLogin> {
  // Khai báo các biến và controller cần thiết
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Biến để theo dõi tình trạng hiển thị mật khẩu
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng nhập"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.person_outline,
                  size: 120,
                  color: Colors.deepPurpleAccent,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.mail),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(height: 16),
                // TextFormField cho mật khẩu đã được cập nhật với chức năng hiển thị/ẩn mật khẩu
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Thay đổi icon dựa vào trạng thái hiển thị mật khẩu
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  autofillHints: const [AutofillHints.password],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    User? user = await _auth.loginUserWithEmailAndPassword(
                        _emailController.text, _passwordController.text
                    );

                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Đã đăng nhập thành công."),
                      ));

                      Navigator.of(context).popAndPushNamed("/");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Có lỗi đăng nhập."),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Đăng nhập",
                    style: TextStyle(fontSize: 24,color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Xử lý cho quên mật khẩu hoặc đăng ký
                  },
                  child: const Text("Quên mật khẩu?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}