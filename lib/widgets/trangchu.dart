import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:thedogs/api/api_call.dart';
import 'package:thedogs/models/user_interface.dart';
import 'package:thedogs/widgets/components/breeds.dart';
import '../firebase_authentication/firebase_auth.dart';

class MyContent extends StatefulWidget {
  @override
  State<MyContent> createState() => _MyContentState();
}

class _MyContentState extends State<MyContent> {
  FirebaseAuthService _auth = FirebaseAuthService();
  List _randomImage = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final image = await APICallGET().fetchData(
          'images/search?mime_types=png&format=json&has_breeds=false&include_breeds=0&order=RANDOM&limit=20',
          false);
      setState(() {
        _randomImage = image.map((e) => e).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // Kiểm tra liệu có dữ liệu người dùng hay không
          if (snapshot.hasData) {
            // Người dùng đã đăng nhập, hiển thị nội dung
            final width = MediaQuery.of(context).size.width;
            // fetchData();
            // print(_randomImage);
            return Consumer<UserInterface>(builder: (context, ui, child) {
              return StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    return Scaffold(
                      appBar: AppBar(
                        toolbarHeight: 70,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Xin chào,",
                                    style: TextStyle(color: Colors.blue[400]),
                                  ),
                                  snapshot.data == null
                                      ? Text(
                                          "Bạn chưa đăng nhập",
                                          style: TextStyle(
                                              color: ui.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                        )
                                      : RichText(
                                          text: const TextSpan(children: [
                                          TextSpan(
                                              text: "Dương",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black)),
                                          TextSpan(text: '  '),
                                          TextSpan(
                                              text: '👋',
                                              style: TextStyle(fontSize: 20))
                                        ]))
                                ]),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: IconButton(
                                  onPressed: () {
                                    snapshot.data == null
                                        ? Navigator.of(context)
                                            .pushNamed("/login")
                                        : Navigator.of(context)
                                            .pushNamed("/settings");
                                  },
                                  // style: ButtonStyle(
                                  //     //   backgroundColor:
                                  //     //       MaterialStateProperty.all(Colors.blue[400]),
                                  //     //   padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  //     //   minimumSize:
                                  //     //       MaterialStateProperty.all(const Size(50, 50)),
                                  //     //   maximumSize:
                                  //     //       MaterialStateProperty.all(const Size(50, 50)),
                                  //     ),
                                  icon: Icon(
                                    snapshot.data == null
                                        ? Icons.account_circle_sharp
                                        : Icons.account_circle,
                                    size: 50,
                                    color: ui.isDarkMode
                                        ? Colors.white
                                        : Colors.blue[400],
                                  )),
                            )
                          ],
                        ),
                        backgroundColor: ui.isDarkMode
                            ? const Color(0xff8b8b8b)
                            : Colors.white,
                        surfaceTintColor: Colors.transparent,
                        foregroundColor: Colors.blue,
                        shadowColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                      ),
                      body: DefaultTextStyle.merge(
                          style: TextStyle(
                              color:
                                  ui.isDarkMode ? Colors.white : Colors.black,
                              fontSize: 20),
                          child: Container(
                              color: ui.isDarkMode
                                  ? const Color(0xff8b8b8b)
                                  : Colors.white,
                              padding: const EdgeInsets.only(
                                  top: 0, left: 10.0, bottom: 10, right: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    99, 99, 99, 0.2),
                                                spreadRadius: 0,
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              )
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: TextField(
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              cursorColor: Colors.blue[400],
                                              decoration: InputDecoration(
                                                  hintText: 'Tìm kiếm',
                                                  hintStyle: TextStyle(
                                                      // height: 2,
                                                      fontSize: 20,
                                                      color: Colors.grey[400]),
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    size: 30,
                                                    color: Colors.blue[400],
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          BorderSide.none),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10)),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      Material(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue[400],
                                        child: SizedBox(
                                          height: 200,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                top: 20,
                                                right: 15,
                                                bottom: 20),
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            "Tìm hiểu sự thật về chó mỗi ngày? 🐶",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          TextButton(
                                                            onPressed: () {},
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                              shape:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              "Xem ngay",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .blue[400],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Positioned(
                                                    right: -5,
                                                    bottom: 0,
                                                    child: Container(
                                                      width: 180,
                                                      height: 100,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            79, 238, 238, 238),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .elliptical(
                                                                        180,
                                                                        100)),
                                                      ),
                                                    )),
                                                const Positioned(
                                                  top: -80,
                                                  right: -30,
                                                  child: Image(
                                                    image: AssetImage(
                                                        "lib/assets/images/image_dog_banner.png"),
                                                    width: 250,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Các loài chó",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed("/list_breeds");
                                            },
                                            child: Text(
                                              "Xem thêm",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blue[400]),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 320,
                                        child: Breeds(
                                          direction: Axis.horizontal,
                                          displayType: 'list',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      CarouselSlider(
                                        items: _randomImage
                                            .map((e) => ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    e['url'],
                                                    fit: BoxFit.cover,
                                                    width: 400,
                                                  ),
                                                ))
                                            .toList(),
                                        options: CarouselOptions(
                                          autoPlay: true,
                                          aspectRatio: 2.0,
                                          enlargeCenterPage: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 100,
                                      )
                                    ]),
                              ))),
                      extendBody: true,
                      floatingActionButton: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ui.isDarkMode
                                ? const Color(0xff8b8b8b)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: ui.isDarkMode
                                    ? Colors.transparent
                                    : Color.fromRGBO(99, 99, 99, 0.2),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              )
                            ]),
                        child: NavigationBar(
                          height: 60,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          destinations: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.home_outlined,
                                color:
                                    ui.isDarkMode ? Colors.white : Colors.black,
                              ),
                              highlightColor: Colors.white,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed("/infodogs");
                              },
                              icon: Icon(
                                Icons.format_list_bulleted_outlined,
                                color:
                                    ui.isDarkMode ? Colors.white : Colors.black,
                              ),
                              highlightColor: Colors.white,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed("/favorite");
                              },
                              icon: Icon(
                                Icons.favorite_outline,
                                color:
                                    ui.isDarkMode ? Colors.white : Colors.black,
                              ),
                              highlightColor: Colors.white,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed("/settings");
                              },
                              icon: Icon(
                                Icons.person_outlined,
                                color:
                                    ui.isDarkMode ? Colors.white : Colors.black,
                              ),
                              highlightColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                      floatingActionButtonAnimator:
                          FloatingActionButtonAnimator.scaling,
                    );
                  });
            });
            // return Scaffold(
            //   appBar: AppBar(
            //     title: const Text("Nội dung chính"),
            //     backgroundColor: Colors.pink,
            //   ),
            //   body: Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         ElevatedButton(
            //           onPressed: () async {
            //             await _auth.signOut();
            //             Navigator.of(context).popAndPushNamed("/");
            //           },
            //           child: const Text(
            //             "Đăng xuất",
            //             style: TextStyle(
            //               fontSize: 30,
            //             ),
            //           ),
            //         ),
            //         const SizedBox(height: 20), // Khoảng cách giữa các nút
            //         ElevatedButton(
            //           onPressed: () {
            //             Navigator.of(context).pushNamed("/infodogs");
            //           },
            //           child: const Text(
            //             "Danh sách các loài chó",
            //             style: TextStyle(
            //               fontSize: 30,
            //             ),
            //           ),
            //         ),
            //         ElevatedButton(
            //           onPressed: () {
            //             Navigator.of(context).pushNamed("/favorite");
            //           },
            //           child: const Text(
            //             "Danh sách yêu thích của tôi",
            //             style: TextStyle(
            //               fontSize: 30,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // );
          } else {
            // Người dùng chưa đăng nhập, chuyển hướng tới trang đăng nhập
            WidgetsBinding.instance.addPostFrameCallback((_) {
              //   Navigator.of(context).popAndPushNamed("/start");
            });
            // Trả về Container trống khi chờ chuyển hướng
            return Container();
          }
        } else {
          // Trả về một Widget chờ khi kết nối vẫn đang thiết lập
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
