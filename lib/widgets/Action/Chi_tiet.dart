import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thedogs/testcode.dart';




void showDogDetails(BuildContext context, Dog dog) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
              margin: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  ListTile(
                    leading: Icon(Icons.pets), // Thêm icon ở đầu thông tin
                    title: Text(
                      '${dog.name}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.tag), // Thêm icon mã
                    title: Text(
                      'Mã: ${dog.id}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.hourglass_bottom), // Thêm icon tuổi thọ
                    title: Text(
                      'Tuổi thọ: ${dog.lifeSpan}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.straighten), // Thêm icon chiều cao
                    title: Text(
                      'Chiều cao: ${dog.height} cm',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.monitor_weight), // Thêm icon cân nặng
                    title: Text(
                      'Cân nặng: ${dog.weight} kg',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Đóng dialog
                      },
                      child: Text('Đóng'),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 16,
              right: 16,
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 50,
                backgroundImage: NetworkImage(dog.imageUrl), // Hiển thị hình ảnh của chó
              ),
            ),
          ],
        ),
      );
    },
  );
}

