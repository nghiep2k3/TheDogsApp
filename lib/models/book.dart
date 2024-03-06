class Book {
  String title;
  String author;
  String coverImage;
  int quantity;
  String category;
  DateTime? borrowedDate;

  Book({
    required this.title,
    required this.author,
    required this.coverImage,
    required this.quantity,
    required this.category,
    this.borrowedDate,
  });
}

// List<Book> borrowedBooks = [
//   Book(
//       title: 'AAA',
//       coverImage:
//           'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2023/06/Sach-hay.jpg',
//       author: '',
//       quantity: 10,
//       category: 'Kỹ thuật phần mềm BBB',
//       borrowedDate: DateTime.parse('2021-10-10')),
//   Book(
//       title: 'BBB',
//       coverImage:
//           'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2023/06/Sach-hay.jpg',
//       author: '',
//       quantity: 10,
//       category: 'Kỹ thuật phần mềm',
//       borrowedDate: DateTime.parse('2021-10-10')),
//   Book(
//       title: 'CCC',
//       coverImage:
//           'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2023/06/Sach-hay.jpg',
//       author: '',
//       quantity: 10,
//       category: 'Kỹ thuật phần mềm',
//       borrowedDate: DateTime.parse('2021-10-10')),
//   Book(
//       title: 'Lập Trình Flutter',
//       coverImage:
//           'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2023/06/Sach-hay.jpg',
//       author: '',
//       quantity: 10,
//       category: 'Kỹ thuật phần mềm',
//       borrowedDate: DateTime.parse('2021-10-10')),
//   Book(
//       title: 'Lập Trình Flutter',
//       coverImage:
//           'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2023/06/Sach-hay.jpg',
//       author: '',
//       quantity: 10,
//       category: 'Kỹ thuật phần mềm',
//       borrowedDate: DateTime.parse('2021-10-10')),
// ];
