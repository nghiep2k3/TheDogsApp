import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thedogs/models/user_interface.dart';
import 'package:http/http.dart' as http;

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  List<dynamic> _data = [];
  bool _isLoading = true; // Biến đánh dấu trạng thái đang tải

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const apiKey = 'DEMO-API-KEY';
    final response = await http.get(
      Uri.parse(
          'https://api.thecatapi.com/v1/images/search?size=med&mime_types=jpg&format=json&has_breeds=true&order=RANDOM&page=0&limit=5'),
      headers: {'x-api-key': apiKey},
    );
    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
        _isLoading = false; // Khi đã có dữ liệu, đặt trạng thái đang tải thành false
      });
    } else {
      throw Exception('Failed to load breeds');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true; // Đặt trạng thái đang tải thành true khi bắt đầu load lại dữ liệu
    });
    await fetchData(); // Gọi lại fetchData() để tải lại dữ liệu
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInterface>(builder: (context, ui, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nhà phát triển'),
          centerTitle: true,
          backgroundColor: ui.appBarColor,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData, // Gọi _refreshData() khi kéo xuống để làm mới trang
          child: _isLoading // Kiểm tra trạng thái đang tải
              ? const Center(
                  child: CircularProgressIndicator(),
                ) // Nếu đang tải, hiển thị CircularProgress
              : ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final imageUrl = _data[index]['url'];
                    final breedName = _data[index]['breeds'][0]['name']; // Lấy thuộc tính "name" từ phần tử đầu tiên trong mảng "breeds"
                    return ListTile(
                      title: Text(breedName),
                      subtitle: Column(
                        children: [
                          Text('URL: $imageUrl'),
                          Container(
                            width: 400,
                            height: 400,
                            child: Align(
                              alignment: Alignment.center,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      );
    });
  }
}
