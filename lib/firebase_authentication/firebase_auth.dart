import "package:firebase_auth/firebase_auth.dart";

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerUserWithEmailAndPassword(String strEmail, String strPassword) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: strEmail, password: strPassword);
      return credential.user;
    } catch (err) {
      print("Co loi tao user: $err");
    }
  }

  Future<User?> loginUserWithEmailAndPassword(String strEmail, String strPassword) async {
    if (strEmail.isEmpty || strPassword.isEmpty) {
      print("Email và mật khẩu không được để trống.");
      return null;
    }

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: strEmail, password: strPassword);
      print("Đăng nhập thành công với user ID: ${credential.user?.uid}");
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Xử lý theo từng mã lỗi cụ thể do Firebase Auth trả về
      if (e.code == 'user-not-found') {
        print("Không có người dùng nào với email này.");
      } else if (e.code == 'wrong-password') {
        print("Sai mật khẩu.");
      } else if (e.code == 'user-disabled') {
        print("Tài khoản người dùng đã bị vô hiệu hóa.");
      } else if (e.code == 'too-many-requests') {
        print("Quá nhiều yêu cầu đăng nhập liên tục. Vui lòng thử lại sau.");
      } else {
        print("Đăng nhập thất bại: ${e.code}");
      }
      return null;
    } catch (e) {
      print("Lỗi không xác định trong quá trình đăng nhập: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      print("Co loi dang xuat: $err");
    }
  }
}