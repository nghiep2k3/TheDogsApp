import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BreedGroup {
  final String breedGroupName;
  final String breedGroupImageUrl;

  BreedGroup({
    required this.breedGroupName,
    required this.breedGroupImageUrl,
  });

  factory BreedGroup.fromJson(Map<String, dynamic> json) {
    return BreedGroup(
      breedGroupName: json['name'],
      breedGroupImageUrl: json['image_url'],
    );
  }
}




class BreedGroupScreen extends StatefulWidget {
  BreedGroupScreen({Key? key}) : super(key: key);

  @override
  _BreedGroupScreenState createState() => _BreedGroupScreenState();
}

class _BreedGroupScreenState extends State<BreedGroupScreen> {
  List<BreedGroup> breedGroups = [];

  bool isLoading = true;

  int _page = 0;
  int _limit = 10; // Giới hạn số lượng nhóm giống chó sẽ được lấy mỗi lần

  Future<void> fetchBreedGroups() async {
    const apiKey = 'DEMO-API-KEY';
    final uri = Uri.parse(
        'https://api.thedogapi.com/v1/breeds?page=$_page&limit=$_limit'
    );

    final response = await http.get(uri, headers: {'x-api-key': apiKey});

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        breedGroups = data.map((groupData) {
          // Xử lý JSON để tạo đối tượng BreedGroup
          String name = groupData['name'] ?? 'Unknown';
          String imageUrl = groupData['image'] != null
              ? groupData['image']['url']
              : 'default_image_url'; // Replace with a valid placeholder image URL if necessary

          return BreedGroup(breedGroupName: name, breedGroupImageUrl: imageUrl);
        }).toList();

        isLoading = false; // Dữ liệu đã tải xong
      });
    } else {
      // Xử lý trường hợp gọi API không thành công
      throw Exception('Failed to load breed groups');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBreedGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhóm Giống Chó'),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: breedGroups.length,
        itemBuilder: (context, index) {
          final group = breedGroups[index];
          return ListTile(
            title: Text(group.breedGroupName),
            leading: group.breedGroupImageUrl.isNotEmpty
                ? Image.network(group.breedGroupImageUrl, width: 50, height: 50)
                : null, // Hiển thị ảnh hoặc một placeholder nếu không có ảnh
          );
        },
      ),
    );
  }
}


