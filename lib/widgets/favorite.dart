import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thedogs/testcode.dart'; // Giả định này chứa định nghĩa của Dog và Dog.fromJson
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesDogsPage extends StatefulWidget {
  @override
  _FavoritesDogsPageState createState() => _FavoritesDogsPageState();
}

class _FavoritesDogsPageState extends State<FavoritesDogsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Phương thức xóa một loài chó từ favorites
  void _removeDogFromFirestore(String docId) {
    User? user = _auth.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(docId)
          .delete()
          .then((_) => print('Document deleted'))
          .catchError((error) => print('Delete failed: $error'));
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Danh sách chó yêu thích'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Bạn cần đăng nhập để xem yêu thích.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách  ${user.displayName ?? 'Người dùng'}'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Không có chó yêu thích nào được tìm thấy'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final dynamic data = document.data();
              if (data is Map<String, dynamic>) {
                Dog dog;
                try {
                  dog = Dog.fromJson(data);
                } catch (e) {
                  print('Error parsing Dog data: $e');
                  return SizedBox.shrink(); // trả về widget trống nếu parse lỗi
                }

                return Dismissible(
                  key: Key(document.id),
                  onDismissed: (direction) {
                    _removeDogFromFirestore(document.id);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(dog.imageUrl ?? ''), // Kiểm tra null cho imageUrl
                    ),
                    title: Text(dog.name ?? 'Unknown'), // Kiểm tra null cho name
                    subtitle: Text(dog.lifeSpan ?? 'Unknown'), // Kiểm tra null cho lifeSpan
                  ),
                );
              } else {
                return Center(child: Text('Dữ liệu không hợp lệ'));
              }
            }).toList(),
          );
        },
      ),
    );
  }
}