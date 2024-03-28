import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesDogsPage extends StatefulWidget {
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
        SnackBar(content: Text('You must be logged in to remove favorites')),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection(docId) // Sử dụng docId được truyền vào để xác định document cần xóa.
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meal successfully removed from favorites')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove meal: $error')),
      );
    }
  }







  Future<List<Map<String, dynamic>>> _getFavoritesDogs() async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    QuerySnapshot querySnapshot =
    await db.collection('users').doc(user.uid).collection('favorites').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Dogs List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getFavoritesDogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite dogs found.'));
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
                  await _removeDogFromFirestore(dog.id); // Giả định rằng dog.id là ID của document.
                  setState(() {
                    dogsList.removeAt(index); // Xóa chó khỏi danh sách được hiển thị.
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Removed ${dog.name} from favorites'),
                      duration: Duration(seconds: 2),
                    ),
                  );
    },
                background: Container(
                  color: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: AlignmentDirectional.centerEnd,
                  child: Icon(Icons.delete, color: Colors.white),
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
                            Icon(Icons.hourglass_full),
                            SizedBox(width: 8),
                            Text('Life Span: ${dog.lifeSpan}'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.monitor_weight_outlined),
                            SizedBox(width: 8),
                            Text('Weight: ${dog.weight}'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.height),
                            SizedBox(width: 8),
                            Text('Height: ${dog.height}'),
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


