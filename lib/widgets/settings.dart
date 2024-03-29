import 'package:thedogs/firebase_authentication/firebase_auth.dart';

import '/models/user_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySettings extends StatelessWidget {
  MySettings({super.key});
  FirebaseAuthService _auth = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return Consumer<UserInterface>(builder: (context, ui, child) {
      return Scaffold(
        appBar: AppBar(
            title: Text(
              "Cài đặt",
              style:
                  TextStyle(color: ui.isDarkMode ? Colors.white : Colors.black),
            ),
            backgroundColor:
                ui.isDarkMode ? const Color(0xff8b8b8b) : Colors.white,
            surfaceTintColor: Colors.white,
            foregroundColor: Colors.black,
            shadowColor: Colors.black,
            iconTheme: IconThemeData(
              color: ui.isDarkMode ? Colors.white : Colors.black,
            )),
        body: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: ui.fontSize,
            color: ui.isDarkMode ? Colors.white : Colors.black,
          ),
          child: Container(
            color: ui.isDarkMode ? const Color(0xff8b8b8b) : Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Center(
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Image(
                              image:
                                  AssetImage("lib/assets/images/image_avt.jpg"),
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Nguyễn Văn A',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "a.nguyenvan@gmail.com",
                      style: TextStyle(
                          fontSize: 16,
                          color: ui.isDarkMode ? Colors.white : Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[300]),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        surfaceTintColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: const Text(
                        "Sửa hồ sơ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
                const Text(
                  "Cài đặt",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
                //   const SizedBox(
                //     height: 20,
                //   ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ui.isDarkMode
                            ? const Icon(
                                Icons.dark_mode,
                                color: Colors.white,
                              )
                            : const Icon(Icons.wb_sunny),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Chế độ tối",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Switch(
                      value: ui.isDarkMode,
                      onChanged: (newValue) {
                        ui.isDarkMode = newValue;
                      },
                      inactiveThumbColor: Colors.white,
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xff49ba68),
                      inactiveTrackColor: const Color(0xffd1d1d1),
                      trackOutlineColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/favorite");
                    },
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      surfaceTintColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor: MaterialStateProperty.all(
                          Colors.grey.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color:
                                  ui.isDarkMode ? Colors.white : Colors.black,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Yêu thích",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: ui.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: ui.isDarkMode ? Colors.white : Colors.black,
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
        floatingActionButton: ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).popAndPushNamed("/start");
            },
            child: Text("Đăng xuất")),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // appBar: AppBar(
        //   title: Text("Settings"),
        //   backgroundColor: Colors.transparent,
        //   surfaceTintColor: Colors.white,
        //   foregroundColor: Colors.black,
        //   shadowColor: Colors.black,
        // ),
        // drawer: MyDrawer(),
        // body: DefaultTextStyle(
        //   style: TextStyle(
        //     fontSize: ui.fontSize,
        //     color: ui.isDarkMode ? Colors.white : Colors.black,
        //   ),
        //   child: Container(
        //     color: ui.isDarkMode ? Color.fromARGB(255, 0, 0, 0) : Colors.white,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           "Font size: ${ui.fontSize.toInt()}",
        //           style: TextStyle(
        //             fontSize: 20,
        //           ),
        //         ),
        //         Slider(
        //           min: 1,
        //           max: 100,
        //           value: ui.fontSize,
        //           onChanged: (newValue) {
        //             ui.fontSize = newValue;
        //           },
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             Text(
        //               "AppBar color:",
        //               style: TextStyle(
        //                 fontSize: 20,
        //               ),
        //             ),
        //             Container(
        //               //   padding: EdgeInsets.only(left: 10, right: 10),
        //               //   decoration: BoxDecoration(
        //               //     //   borderRadius: BorderRadius.circular(10),
        //               //     color: ui.isDarkMode ? Colors.white : Colors.black,
        //               //   ),
        //               child: DropdownButton<String>(
        //                   value: ui.strAppBarColor,
        //                   style: TextStyle(
        //                     color: ui.isDarkMode ? Colors.white : Colors.black,
        //                   ),
        //                   dropdownColor: ui.isDarkMode
        //                       ? Color.fromARGB(255, 0, 0, 0)
        //                       : Colors.white,
        //                   items: UserInterface.listColorAppBar
        //                       .map<DropdownMenuItem<String>>((String value) {
        //                     return DropdownMenuItem<String>(
        //                       value: value,
        //                       child: Text(value),
        //                     );
        //                   }).toList(),
        //                   onChanged: (String? value) {
        //                     ui.appBarColor = value;
        //                   }),
        //             )
        //           ],
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(20.0),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: [
        //               Text(
        //                 "Dark mode:",
        //                 style: TextStyle(
        //                   fontSize: 20,
        //                 ),
        //               ),
        //               Switch(
        //                 value: ui.isDarkMode,
        //                 onChanged: (newValue) {
        //                   ui.isDarkMode = newValue;
        //                 },
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      );
    });
  }
}
