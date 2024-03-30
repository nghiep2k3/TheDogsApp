import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thedogs/api/api_call.dart';
import 'package:thedogs/models/user_interface.dart';

class Breeds extends StatefulWidget {
  const Breeds({super.key, required this.direction, required this.displayType});
  final Axis direction;
  final String displayType;
  @override
  State<Breeds> createState() => _BreedsState();
}

class _BreedsState extends State<Breeds> {
  List _breeds = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final breeds = await APICallGET().fetchData('breeds?limit=10', true);
      setState(() {
        _breeds = breeds.map((e) => e).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets? margin;
    EdgeInsets? marginFirst;
    if (widget.direction == Axis.horizontal) {
      marginFirst = const EdgeInsets.only(left: 0, right: 10);
      margin = const EdgeInsets.only(left: 10, right: 10);
    }
    return Consumer<UserInterface>(builder: (context, ui, child) {
      return FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            final displayType = widget.displayType;
            return displayType == 'grid'
                ? Container(
                    //   height: 300,

                    child: DefaultTextStyle.merge(
                      style: const TextStyle(color: Colors.black),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.8),
                        itemCount: _breeds.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/breed_detail',
                                  arguments: _breeds[index]);
                            },
                            child: Container(
                              // height: 400,
                              // margin: index == 0 ? marginFirst : margin,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      'https://cdn2.thedogapi.com/images/${_breeds[index]['reference_image_id']}.jpg',
                                      width: 230,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        children: [
                                          Text(
                                            _breeds[index]['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(_breeds[index]['life_span']),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    // Wrap ListView.builder with a Container widget
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(color: Colors.black),
                      child: ListView.builder(
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //   crossAxisCount: 2
                        // ),
                        scrollDirection: widget.direction,
                        itemCount:
                            _breeds.length, // Đặt số lượng mục trong danh sách
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/breed_detail',
                                arguments: _breeds[index]);
                          },
                          child: Container(
                              width: 250,
                              height: 320,
                              margin: index == 0 ? marginFirst : margin,
                              child: Container(
                                height: 300,
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: ui.isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: ui.isDarkMode
                                            ? const Color.fromRGBO(
                                                255, 255, 255, 0.2)
                                            : const Color.fromRGBO(
                                                99, 99, 99, 0.2),
                                        spreadRadius: 0,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ]),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        'https://cdn2.thedogapi.com/images/${_breeds[index]['reference_image_id']}.jpg',
                                        width: 230,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      _breeds[index]['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(_breeds[index]['life_span']
                                        .replaceAll(' years', ' tuổi'))
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  );
          });
    });
  }
}
