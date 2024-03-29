import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thedogs/api/api_key.dart';

class APICallGET {
  Future<List> fetchData(String url, bool hasHeader) async {
    final response = await http.get(
      Uri.parse('https://api.thedogapi.com/v1/$url'),
      // headers: hasHeader
      //     ? {'x-api-key': apiKey, 'Content-Type': 'application/json'}
      //     : {},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

// class APICallPOST {
//   static Future fetchData(url, body) async {
//     final response = await http.post(
//       Uri.parse("https://api.thecatapi.com/v1/$url"),
//       headers: {
//         'x-api-key': apiKey,
//         'Content-Type': 'application/json',
//       },
//       body: body,
//     );
//     return response;
//   }
// }
