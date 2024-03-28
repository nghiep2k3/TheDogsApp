import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thedogs/widgets/Action/Chi_tiet.dart';

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

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      name: json['breeds'][0]['name'],
      id: json['id'],
      imageUrl: json['url'],
      lifeSpan: json['breeds'][0]['life_span'],
      weight: json['breeds'][0]['weight']['metric'],
      height: json['breeds'][0]['height']['metric'],
    );
  }
}

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  List<Dog> _dogs = [];
  List<Dog> _filteredDogs = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  int _page = 0;
  int _limit = 6;
  int likeCount = 1;

  String apiKey =
      'live_K9uSZYz4F58HqbFbcoxswpRHd2INjIkoNyiUjDcOMLsxE6Mr56RzgBPSrJ8b1l5A';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // const Key = apiKey;
    final response = await http.get(
      Uri.parse(
          'https://api.thedogapi.com/v1/images/search?size=med&mime_types=jpg&format=json&has_breeds=true&order=ASC&page=$_page&limit=$_limit&include_breeds=1'),
      headers: {'x-api-key': apiKey},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _dogs = data.map((dogData) => Dog.fromJson(dogData)).toList();
        _filteredDogs = _dogs;
        _isLoading = false; // Kết thúc tải dữ liệu
      });
    } else {
      throw Exception('Failed to load breeds');
    }
  }

  void _filterDogs(String query) {
    setState(() {
      _filteredDogs = query.isEmpty
          ? _dogs
          : _dogs
              .where(
                  (dog) => dog.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  // post data
  void _addToFavorites(Dog dog) async {
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    print(userUID);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('favorites')
        .add(dog.toJson())
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

  // hiển thị chi tiết thông tin
  void _showDogDetails(Dog dog) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Thông tin các loại chó'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterDogs,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(), // Hiển thị nút quay tròn khi đang tải dữ liệu
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      final dog = _filteredDogs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          width: double.infinity, // Khung có chiều ngang tối đa
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                                child: Image.network(
                                  dog.imageUrl, // Đường dẫn đến ảnh của chó
                                  fit: BoxFit
                                      .fill, // Ảnh sẽ lấp đầy khung theo chiều ngang
                                ),
                              ),
                              const SizedBox(
                                  height: 10), // Khoảng cách giữa ảnh và tên
                              Text(
                                "Name: ${dog.name}", // Tên của chó
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.center, // Căn giữa tên
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        // Xử lý sự kiện khi người dùng nhấn vào nút "Vote"
                                        // Tạm thời chỉ tăng số lượt thích ở giao diện, không lưu vào cơ sở dữ liệu
                                        likeCount++; // Tăng số lượt thích của chó lên 1
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.heart,
                                              color: Colors.red,
                                              size: 27,
                                            ),
                                            Text(
                                              '${likeCount}', // Hiển thị số lượt thích của chó
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                            height:
                                                5), // Khoảng cách giữa biểu tượng và chữ
                                        const Text("Vote"),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      print(dog);
                                      _addToFavorites(dog);
                                      //call api - post
                                    },
                                    child: const Column(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.bookmark,
                                          color: Colors.blue,
                                          size: 25,
                                        ),
                                        SizedBox(
                                            height:
                                                5), // Khoảng cách giữa biểu tượng và chữ
                                        Text("Favourites"),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showDogDetails(context,
                                          dog); // Hiển thị thông tin chi tiết khi nhấn vào nút "Chi tiết"
                                    },
                                    child: const Column(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.circleInfo,
                                          color: Colors.blue,
                                          size: 25,
                                        ),
                                        SizedBox(
                                            height:
                                                5), // Khoảng cách giữa biểu tượng và chữ
                                        Text("Chi tiết"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Khoảng cách giữa tên và ID
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: _filteredDogs.length,
                  ),
          ),
        ],
      ),
      //điều hướng ở dưới
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (_page > 0) {
                    _isLoading = true;
                    _page--; // Giảm trang nếu trang hiện tại lớn hơn 0
                    fetchData(); // Tải dữ liệu mới
                  }
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Text('Trang: ${_page + 1}'),
            IconButton(
              onPressed: () {
                setState(() {
                  _page++; // Tăng trang
                  _isLoading =
                      true; // Cập nhật giá trị của _isLoading thành true
                  fetchData(); // Tải dữ liệu mới
                });
              },
              icon: const Icon(Icons.arrow_forward),
            ),
            DropdownButton<int>(
              value: _limit,
              items: List.generate(
                10,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text((index + 1).toString()),
                ),
              ),
              onChanged: (int? value) {
                setState(() {
                  _isLoading = true;
                  _limit = value!;
                  fetchData(); // Tải dữ liệu mới với limit mới
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
