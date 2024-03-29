// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesDogsPage extends StatefulWidget {
  const FavoritesDogsPage({super.key});

  @override
  _FavoritesDogsPageState createState() => _FavoritesDogsPageState();
}

class _FavoritesDogsPageState extends State<FavoritesDogsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> _removeDogFromFirestore(String docId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to remove favorites')),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(docId)
          .delete();

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content: Text('Xóa thành công')),
      // );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi ?: $error')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _getFavoritesDogs() async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    QuerySnapshot querySnapshot = await db
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();
    List<Map<String, dynamic>> favoritesList = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['docId'] = doc.id;
      favoritesList.add(data);
    });
    return favoritesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites Dogs List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getFavoritesDogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite dogs found.'));
          }

          List<Map<String, dynamic>> dogsList = snapshot.data!;

          return ListView.builder(
            itemCount: dogsList.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> dogData = dogsList[index];
              Dog dog = Dog.fromJson(dogData);

              return Dismissible(
                key: Key(dog.id), // Đảm bảo rằng key là duy nhất cho mỗi item.
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await _removeDogFromFirestore(dogData[
                      'docId']); // Sử dụng docId của document để xóa khỏi Firestore
                  setState(() {
                    dogsList.removeAt(
                        index); // Xóa chó khỏi danh sách được hiển thị.
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa con ${dog.name} từ mục yêu thích'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },

                background: Container(
                  color: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: AlignmentDirectional.centerEnd,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(dog.imageUrl),
                          ),
                          title: Text(dog.name),
                          subtitle: Text('ID: ${dog.id}'),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.hourglass_full),
                            const SizedBox(width: 8),
                            Text('Life Span: ${dog.lifeSpan}'),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.monitor_weight_outlined),
                            const SizedBox(width: 8),
                            Text('Weight: ${dog.weight}'),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.height),
                            const SizedBox(width: 8),
                            Text('Height: ${dog.height}'),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.document_scanner_outlined),
                            const SizedBox(width: 8),
                            Text('Docid: ${dogData['docId']}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Dog {
  final String id;
  final String name;
  final String imageUrl;
  final String lifeSpan;
  final String weight;
  final String height;

  Dog({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lifeSpan,
    required this.weight,
    required this.height,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      lifeSpan: json['lifeSpan'] ?? '',
      weight: json['weight'] ?? '',
      height: json['height'] ?? '',
    );
  }
}
