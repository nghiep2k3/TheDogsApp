import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_authentication/firebase_auth.dart';

// Chuyển MyRegister thành StatefulWidget
class MyRegister extends StatefulWidget {
  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Biến để quản lý hiển thị mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng ký"),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Thêm padding vào body
        child: Center(
          child: SingleChildScrollView( // Chỉnh lại layout và thêm cuộn
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Icon(
                  Icons.account_box,
                  size: 120,
                  color: Colors.deepPurpleAccent,
                ),
                TextFormField( // Sử dụng TextFormField thay vì TextField
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Nhập email của bạn',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                ),
                SizedBox(height: 20),
                TextFormField( // Thêm TextFormField cho mật khẩu
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, // Ẩn mật khẩu dựa vào trạng thái của _isPasswordVisible
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu của bạn',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: _isPasswordVisible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible; // Thay đổi trạng thái hiển thị mật khẩu
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.yellow, // Màu của text và icon trên nút
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Padding cho nút
                  ),
                  onPressed: () async {
                    User? user = await _auth.registerUserWithEmailAndPassword(
                        _emailController.text, _passwordController.text
                    );

                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Đã đăng ký thành công."),
                      ));

                      Navigator.of(context).popAndPushNamed("/");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Có lỗi đăng ký."),
                      ));
                    }
                  },
                  child: Text("Đăng ký", style: TextStyle(fontSize: 24)),
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    // Điều hướng người dùng về trang đăng nhập nếu họ đã có tài khoản
                    Navigator.of(context).pop();
                  },
                  child: Text('Điều hướng về trang Đăng nhập'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}