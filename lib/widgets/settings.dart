import '/widgets/components/my_drawer.dart';
import '/models/user_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserInterface>(builder: (context, ui, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          backgroundColor: ui.appBarColor,
        ),
        drawer: MyDrawer(),
        body: DefaultTextStyle(
          style: TextStyle(
            fontSize: ui.fontSize,
            color: ui.isDarkMode ? Colors.white : Colors.black,
          ),
          child: Container(
            color: ui.isDarkMode ? Color.fromARGB(255, 0, 0, 0) : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Font size: ${ui.fontSize.toInt()}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Slider(
                  min: 1,
                  max: 100,
                  value: ui.fontSize,
                  onChanged: (newValue) {
                    ui.fontSize = newValue;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "AppBar color:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      //   padding: EdgeInsets.only(left: 10, right: 10),
                      //   decoration: BoxDecoration(
                      //     //   borderRadius: BorderRadius.circular(10),
                      //     color: ui.isDarkMode ? Colors.white : Colors.black,
                      //   ),
                      child: DropdownButton<String>(
                          value: ui.strAppBarColor,
                          style: TextStyle(
                            color: ui.isDarkMode ? Colors.white : Colors.black,
                          ),
                          dropdownColor:
                              ui.isDarkMode ? Color.fromARGB(255, 0, 0, 0) : Colors.white,
                          items: UserInterface.listColorAppBar
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            ui.appBarColor = value;
                          }),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Dark mode:",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Switch(
                        value: ui.isDarkMode,
                        onChanged: (newValue) {
                          ui.isDarkMode = newValue;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
