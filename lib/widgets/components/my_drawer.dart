import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text("Trang chủ"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context).popAndPushNamed("/"),
          ),
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text("Thông tin các loài chó"),
            onTap: () => Navigator.of(context).popAndPushNamed("/infodogs"),
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text("Search"),
            onTap: () =>
                Navigator.of(context).popAndPushNamed("/search"),
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text("..."),
            onTap: () => Navigator.of(context).popAndPushNamed("/muonsach"),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text("..."),
            onTap: () => Navigator.of(context).popAndPushNamed("/trasach"),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("..."),
            onTap: () => Navigator.of(context).popAndPushNamed("/thongtin"),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Cài đặt"),
            onTap: () => Navigator.of(context).popAndPushNamed("/settings"),
          ),
          ListTile(
            leading: const Icon(Icons.developer_board),
            title: const Text("Chế độ nhà phát triển"),
            onTap: () => Navigator.of(context).popAndPushNamed("/testcode"),
          ),
        ],
      ),
    );
  }
}
