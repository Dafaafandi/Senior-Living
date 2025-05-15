import 'package:http/http.dart' as http;
import 'package:senior_living/model.dart';
import 'dart:convert';

class Repository {
  final _baseUrl = 'http://127.0.0.1:8000/api/admin/users'; // Added semicolon

  Future<List<Blog>?> getdata() async {
    // Added return type
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        print(response.body);
        Iterable it = jsonDecode(response.body);
        List<Blog> blog = it.map((e) => Blog.fromJson(e)).toList();
        return blog;
      }
      return null; // Added return for non-200 status
    } catch (e) {
      print(e.toString());
      return null; // Added return for error case
    }
  }
}
