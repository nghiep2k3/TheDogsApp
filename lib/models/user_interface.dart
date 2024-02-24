import 'package:flutter/material.dart';
import '../models/user.dart';

class UserInterface with ChangeNotifier {
  static List<String> listColorAppBar = <String>[
    'Grey',
    'Purple',
    'Red',
    'Green',
    'Blue'
  ];

  double _fontSize = 15;
  String _appBarColor = 'Grey';
  bool _isDarkMode = false;

  set appBarColor(newColor) {
    _appBarColor = newColor;
    notifyListeners();
  }

  Color get appBarColor {
    switch (_appBarColor) {
      case 'Grey':
        return Colors.grey;
      case 'Purple':
        return Colors.purple;
      case 'Red':
        return Colors.red;
      case 'Green':
        return Colors.green;
      case 'Blue':
        return Colors.blue;
      default:
        return Colors.white;
    }
  }

  String get strAppBarColor => _appBarColor;

  set fontSize(newSize) {
    _fontSize = newSize;
    notifyListeners();
  }

  double get fontSize => _fontSize;
  set isDarkMode(newMode) {
    _isDarkMode = newMode;
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
  List<BorrowerInfo> borrowers = [];
  
  // nhận thông tin
  void addBorrower({
    required String name,
    required String idCard,
    required String phone,
    required String bookCode,
  }) {
    BorrowerInfo borrower = BorrowerInfo(
      borrowerName: name,
      borrowerIdCard: idCard,
      borrowerPhone: phone,
      borrowerBookCode: bookCode,
    );

    borrowers.add(borrower);
    notifyListeners();
  }

  void removeBorrower(BorrowerInfo borrower) {
    borrowers.remove(borrower);
    notifyListeners();
  }


}
