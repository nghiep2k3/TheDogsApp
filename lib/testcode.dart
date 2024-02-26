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
      Uri.parse('https://api.thecatapi.com/v1/breeds?limit=2&page=0'),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInterface>(builder: (context, ui, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nhà phát triển'),
          centerTitle: true,
          backgroundColor: ui.appBarColor,
        ),
        body: _isLoading // Kiểm tra trạng thái đang tải
            ? Center(child: CircularProgressIndicator()) // Nếu đang tải, hiển thị CircularProgress
            : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_data[index]['name']),
                    subtitle: Text(_data[index]['description']),
                  );
                },
              ),
      );
    });
  }
}
