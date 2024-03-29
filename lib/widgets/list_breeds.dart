import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thedogs/api/api_call.dart';
import 'package:thedogs/api/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:thedogs/models/user_interface.dart';
import 'package:thedogs/widgets/components/breeds.dart';

// class Breeds {
//   final String name;
//   final String imageId;

//   Breeds({
//     required this.name,
//     required this.imageId,
//   });

//   factory Breeds.fromJson(Map<String, dynamic> json) {
//     return Breeds(
//       name: json['name'],
//       imageId: json['reference_image_id'],
//     );
//   }
// }

class ListBreeds extends StatefulWidget {
  const ListBreeds({super.key});

  @override
  State<ListBreeds> createState() => _ListBreedsState();
}

class _ListBreedsState extends State<ListBreeds> {
  List _breeds = [];
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final breeds = await APICallGET().fetchData('breeds?limit=10', false);
      setState(() {
        _breeds = breeds.map((item) => item).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInterface>(
      builder: (context, ui, child){
        return Scaffold(
            appBar: AppBar(
              title: Text(
                'Danh sách các loài chó',
                style: TextStyle(color: ui.isDarkMode? Colors.white: Colors.black),
              ),
              backgroundColor: ui.isDarkMode ? const Color(0xff8b8b8b): Colors.white,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
              iconTheme: IconThemeData(color: ui.isDarkMode ? Colors.white: Colors.black),
            ),
            body: Container(
              color: ui.isDarkMode ? const Color(0xff8b8b8b) : Colors.white,
              padding: EdgeInsets.only(top: 0, right: 10, left: 10),
              child: Breeds(
                direction: Axis.vertical,
                displayType: 'grid',
              ),
            ));
      },
    );
  }
}
