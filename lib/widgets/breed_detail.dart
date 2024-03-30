import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thedogs/firebase_authentication/firebase_auth.dart';
import 'package:thedogs/models/user_interface.dart';

class Dog {
  final String name;
  final String id;
  final String imageUrl;
  final String lifeSpan;
  final String weight;
  final String height;

  Dog({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.lifeSpan,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lifeSpan': lifeSpan,
      'height': height,
      'weight': weight,
      'imageUrl': imageUrl,
    };
  }

//   factory Dog.fromJson(Map<String, dynamic> json) {
//     return Dog(
//       name: json['breeds'][0]['name'],
//       id: json['id'],
//       imageUrl: json['url'],
//       lifeSpan: json['breeds'][0]['life_span'],
//       weight: json['breeds'][0]['weight']['metric'],
//       height: json['breeds'][0]['height']['metric'],
//     );
//   }
}

class BreedDetail extends StatefulWidget {
  const BreedDetail({super.key});

  @override
  State<BreedDetail> createState() => _BreedDetailState();
}

class _BreedDetailState extends State<BreedDetail> {
  bool _isFavorite = false;
  String userUID = FirebaseAuth.instance.currentUser!.uid;
  List favorites = [];
  List favoritesList = [];
  void initState() {
    super.initState();
    _getFavorites();
  }

  void _getFavorites() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('favorites')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        favorites.add(doc.data());
      });
      setState(() {
        favorites = favorites;
      });
    });
  }

  Future<void> _addToFavorites(Dog dog) async {
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    print(userUID);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('favorites')
        // .add(dog.toJson())
        .doc(dog.id)
        .set(dog.toJson())
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thêm thành công')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to favorites: $error')),
      );
    });
  }

  Future<void> _deleteFavorite(String docId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('favorites')
        .doc(docId)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa thành công')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi ?: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map breed = ModalRoute.of(context)!.settings.arguments as Map;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // return ;
    print(favorites);
    bool isFavoriteExist = favorites
        .map((item) => item['id'])
        .contains(breed['reference_image_id']);
    return Consumer<UserInterface>(builder: (context, ui, child) {
      return Scaffold(
        //   appBar: AppBar(
        //     title: Text(breed['name']),
        //     backgroundColor: Colors.blue,
        //   ),
        body: DefaultTextStyle.merge(
          style: TextStyle(color: ui.isDarkMode ? Colors.white : Colors.black),
          child: SizedBox(
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.network(
                  'https://cdn2.thedogapi.com/images/${breed['reference_image_id']}.jpg',
                  height: 400,
                  width: width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      width: width,
                      height: height - 350,
                      padding:
                          const EdgeInsets.only(top: 40, left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50)),
                          color: ui.isDarkMode
                              ? const Color(0xff8b8b8b)
                              : Colors.white),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    breed['name'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      //   bool isFavoriteExist = favorites
                                      //       .map((item) => item['id'])
                                      //       .contains(
                                      //           breed['reference_image_id']);
                                      if (isFavoriteExist || _isFavorite) {
                                        await _deleteFavorite(
                                            breed['reference_image_id']);
                                      } else {
                                        await _addToFavorites(Dog(
                                          name: breed['name'],
                                          id: breed['reference_image_id'],
                                          imageUrl:
                                              'https://cdn2.thedogapi.com/images/${breed['reference_image_id']}.jpg',
                                          lifeSpan: breed['life_span'],
                                          weight: breed['weight']['metric'],
                                          height: breed['height']['metric'],
                                        ));
                                      }
                                      //   if (favorites.isEmpty ||
                                      //       !favorites
                                      //           .map((item) => item['id'])
                                      //           .contains(breed[
                                      //               'reference_image_id']) ||
                                      //       _isFavorite) {
                                      //     _addToFavorites(Dog(
                                      //       name: breed['name'],
                                      //       id: breed['reference_image_id'],
                                      //       imageUrl:
                                      //           'https://cdn2.thedogapi.com/images/${breed['reference_image_id']}.jpg',
                                      //       lifeSpan: breed['life_span'],
                                      //       weight: breed['weight']['metric'],
                                      //       height: breed['height']['metric'],
                                      //     ));
                                      //   } else {
                                      //     _deleteFavorite(
                                      //         breed['reference_image_id']);
                                      //   }
                                      setState(() {
                                        _isFavorite =
                                            !isFavoriteExist && !_isFavorite;
                                      });
                                    },
                                    icon: Icon(
                                      (favorites
                                                  .map((item) => item['id'])
                                                  .contains(breed[
                                                      'reference_image_id']) ||
                                              _isFavorite)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: const Color.fromARGB(
                                          255, 238, 40, 132),
                                    ),
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                  //   IconButton(
                                  //     onPressed: () {
                                  //       if (favorites.isEmpty ||
                                  //           !favorites
                                  //               .map((item) => item['id'])
                                  //               .contains(breed[
                                  //                   'reference_image_id'])) {
                                  //         _addToFavorites(Dog(
                                  //           name: breed['name'],
                                  //           id: breed['reference_image_id'],
                                  //           imageUrl:
                                  //               'https://cdn2.thedogapi.com/images/${breed['reference_image_id']}.jpg',
                                  //           lifeSpan: breed['life_span'],
                                  //           weight: breed['weight']['metric'],
                                  //           height: breed['height']['metric'],
                                  //         ));
                                  //       } else {
                                  //         _deleteFavorite(
                                  //             breed['reference_image_id']);
                                  //       }
                                  //       setState(() {
                                  //         _isFavorite = !_isFavorite;
                                  //       });
                                  //     },
                                  //     icon: Icon(
                                  //       (favorites
                                  //               .map((item) => item['id'])
                                  //               .contains(
                                  //                   breed['reference_image_id']))
                                  //           ? Icons.favorite
                                  //           : Icons.favorite_border,
                                  //       color: const Color.fromARGB(
                                  //           255, 238, 40, 132),
                                  //     ),
                                  //     hoverColor: Colors.transparent,
                                  //     highlightColor: Colors.transparent,
                                  //   ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: const Color(0xfffbd9b9)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              breed['life_span']
                                                  .replaceAll(' years', ''),
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            const Text(
                                              'tuổi',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      )),
                                  Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: const Color(0xffdeb9fb)),
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            breed['weight']['metric'],
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                          const Text(
                                            'kg',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          )
                                        ],
                                      ))),
                                  Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: const Color(0xffe9fecf)),
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            breed['height']['metric'],
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                          const Text(
                                            'cm',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          )
                                        ],
                                      ))),
                                ],
                              ),
                              // Text(breed['name']),
                              const SizedBox(height: 20),
                              Text.rich(TextSpan(children: [
                                const TextSpan(
                                    text: 'Nguồn gốc: ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        "${(breed['origin'] != null && breed['origin'] != '') ? breed['origin'] : "Chưa có thông tin"}",
                                    style: const TextStyle(fontSize: 20))
                              ])),
                              const SizedBox(height: 20),
                              Text.rich(TextSpan(children: [
                                const TextSpan(
                                    text: 'Mô tả: ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        "${(breed['bred_for'] != null && breed['bred_for'] != '') ? breed['bred_for'] : "Chưa có thông tin"}",
                                    style: const TextStyle(fontSize: 20))
                              ])),
                              const SizedBox(height: 20),
                              Text.rich(TextSpan(children: [
                                const TextSpan(
                                    text: 'Nhóm: ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text:
                                        "${(breed['breed_group'] != null && breed['breed_group'] != '') ? breed['breed_group'] : "Chưa có thông tin"}",
                                    style: const TextStyle(fontSize: 20))
                              ])),
                              const SizedBox(height: 20),
                              Text.rich(TextSpan(children: [
                                const TextSpan(
                                    text: 'Đặc tính: ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                  text:
                                      "${(breed['temperament'] != null && breed['temperament'] != '') ? breed['temperament'] : "Chưa có thông tin"}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ])),
                              const SizedBox(height: 40),
                              Center(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      //   bool isFavoriteExist = favorites
                                      //       .map((item) => item['id'])
                                      //       .contains(
                                      //           breed['reference_image_id']);
                                      if (isFavoriteExist || _isFavorite) {
                                        await _deleteFavorite(
                                            breed['reference_image_id']);
                                      } else {
                                        await _addToFavorites(Dog(
                                          name: breed['name'],
                                          id: breed['reference_image_id'],
                                          imageUrl:
                                              'https://cdn2.thedogapi.com/images/${breed['reference_image_id']}.jpg',
                                          lifeSpan: breed['life_span'],
                                          weight: breed['weight']['metric'],
                                          height: breed['height']['metric'],
                                        ));
                                      }
                                      //   if (favorites.isEmpty ||
                                      //       !favorites
                                      //           .map((item) => item['id'])
                                      //           .contains(breed[
                                      //               'reference_image_id']) ||
                                      //       _isFavorite) {
                                      //     _addToFavorites(Dog(
                                      //       name: breed['name'],
                                      //       id: breed['reference_image_id'],
                                      //       imageUrl:
                                      //           'https://cdn2.thedogapi.com/images/${breed['reference_image_id']}.jpg',
                                      //       lifeSpan: breed['life_span'],
                                      //       weight: breed['weight']['metric'],
                                      //       height: breed['height']['metric'],
                                      //     ));
                                      //   } else {
                                      //     _deleteFavorite(
                                      //         breed['reference_image_id']);
                                      //   }
                                      setState(() {
                                        _isFavorite =
                                            !isFavoriteExist && !_isFavorite;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff9188e3),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                    ),
                                    child: const Text(
                                      'Thêm vào yêu thích',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    )),
                              ),
                              const SizedBox(height: 20),
                            ]),
                      ),
                    )),
                Positioned(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
