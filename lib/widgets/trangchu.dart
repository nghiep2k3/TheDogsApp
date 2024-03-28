import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_authentication/firebase_auth.dart';

class MyContent extends StatelessWidget {
  FirebaseAuthService _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // Kiểm tra liệu có dữ liệu người dùng hay không
          if (snapshot.hasData) {
            // Người dùng đã đăng nhập, hiển thị nội dung
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
                        Navigator.of(context).pushNamed("/infodogs");
                      },
                      child: const Text(
                        "Danh sách các loài chó",
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
                        "Danh sách yêu thích của tôi",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Người dùng chưa đăng nhập, chuyển hướng tới trang đăng nhập
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popAndPushNamed("/start");
            });
            // Trả về Container trống khi chờ chuyển hướng
            return Container();
          }
        } else {
          // Trả về một Widget chờ khi kết nối vẫn đang thiết lập
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
