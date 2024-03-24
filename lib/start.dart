import 'package:flutter/material.dart';

class SlideshowPage extends StatefulWidget {
  @override
  _SlideshowPageState createState() => _SlideshowPageState();
}

class _SlideshowPageState extends State<SlideshowPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, int index) {
    switch (index) {
      case 0:
        return _firstPageContent();
      case 1:
        return _secondPageContent();
      case 2:
        return _thirdPageContent(context);
      default:
        return Container();
    }
  }
  Widget _firstPageContent() {
    return Container(
      color: Colors.blue[300], // Thêm màu nền
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Expanded(
            flex: 2, // Giảm tỉ lệ của ảnh xuống để thu nhỏ ảnh lại
            child: Container(
              width: 250.0,  // Cố định chiều rộng là 200 pixels
              height: 200.0,
              margin: EdgeInsets.all(16) ,// Thêm margin
              child: Image.asset(
                'assets/Image/anh1.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2, // Phần giới thiệu chiếm 2/5 không gian
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "Welcome to The Dog App",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),

                  textAlign: TextAlign.center,
                ),

              ),
            ),
          ),
          Spacer(), // Phần dưới cùng trống

        ],
      ),
    );
  }

  Widget _secondPageContent() {
    return Container(
      color: Colors.blue[200], // Thêm màu nền
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/Image/anh2.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Chúng tôi sẽ giúp bạn hiêu hơn về những chú chó ',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Spacer(),

        ],
      ),
    );
  }


  Widget _thirdPageContent(BuildContext context) {
    return Container(
      color: Colors.blue[200], // Thêm màu nền
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Expanded(
            flex: 2, // Giữ nguyên này để ảnh chiếm không gian phù hợp
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/Image/anh3.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Giảm độ lớn của Expanded chứa Text xuống
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'Chào mừng bạn đến với ứng dụng!',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Thêm SizedBox để tạo khoảng trống trước Row của các nút
          SizedBox(height: 20), // Có thể điều chỉnh chiều cao phù hợp
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Căn giữa theo chiều ngang
              children: [
                _authButton(context, 'Đăng nhập', () {
                  Navigator.pushNamed(context, '/login');
                }),
                _authButton(context, 'Đăng ký', () {
                  Navigator.pushNamed(context, '/register');
                }),
              ],
            ),
          ),
          // Có thể thêm Spacer để đẩy các nút lên trên
          Spacer(),
        ],
      ),
    );
  }



  Widget _authButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blueAccent, // Màu chữ cho nút
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildPageContent(context, index);
            },
          ),
          if (_currentPage < 2) // Chỉ hiển thị nút NEXT cho hai trang đầu
            Positioned(
              right: 15,
              bottom: 50,
              child: ElevatedButton(
                onPressed: goToNextPage,
                child: Text("NEXT"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, // Flutter 2: backgroundColor -> onPrimary
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildPageIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}