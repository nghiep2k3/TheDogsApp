import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class InfoDogs extends StatefulWidget {
  const InfoDogs({Key? key}) : super(key: key);

  @override
  _InfoDogsState createState() => _InfoDogsState();
}

class _InfoDogsState extends State<InfoDogs> {
  List<Dog> _dogs = [];
  List<Dog> _filteredDogs = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  int _page = 0;
  int _limit = 6;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const apiKey = 'DEMO-API-KEY';
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

  void _showDogDetails(Dog dog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tên: ${dog.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(dog.imageUrl),
              SizedBox(height: 10),
              Text('Tuổi thọ: ${dog.lifeSpan}'),
              Text('Chiều cao: ${dog.height} cm'),
              Text('Cân nặng: ${dog.weight} kg'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                        const CircularProgressIndicator(), // Hiển thị nút quay tròn khi đang tải dữ liệu
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      final dog = _filteredDogs[index];
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tên: ${dog.name}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'ID: ${dog.id}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _showDogDetails(
                                dog); // Hiển thị thông tin chi tiết khi nhấn vào nút "Chi tiết"
                          },
                          child: const Text('Chi tiết'),
                        ),
                      );
                    },
                    itemCount: _filteredDogs.length,
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (_page > 0) {
                    _page--; // Giảm trang nếu trang hiện tại lớn hơn 0
                    fetchData(); // Tải dữ liệu mới
                  }
                });
              },
              icon: Icon(Icons.arrow_back),
            ),
            Text('Trang: ${_page + 1 }'),
            IconButton(
              onPressed: () {
                setState(() {
                  _page++; // Tăng trang
                  fetchData(); // Tải dữ liệu mới
                });
              },
              icon: Icon(Icons.arrow_forward),
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
