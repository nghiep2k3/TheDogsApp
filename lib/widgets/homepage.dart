
import '/widgets/components/my_drawer.dart';
import '/models/user_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer<UserInterface>(
      builder: (context, ui, child) {
        return Scaffold(
          appBar: AppBar(
              title: const Text(
                "Trang chủ",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              backgroundColor: ui.appBarColor,
              iconTheme: const IconThemeData(color: Colors.white)),
          drawer: const MyDrawer(),
          body: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: ui.fontSize,
              color: ui.isDarkMode ? Colors.white : Colors.black,
            ),
            child: Container(
                color: ui.isDarkMode
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : Colors.white,
                padding: const EdgeInsets.all(20.0),
                child: const SingleChildScrollView(
                  child: const Text("ok"),
                )),
          ),
        );
      },
    );
  }
}
