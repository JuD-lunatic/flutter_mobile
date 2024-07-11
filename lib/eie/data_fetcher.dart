import 'dart:convert';
import 'package:http/http.dart' as http;

class DataFetcher {
  Future<List<dynamic>> fetchMergedData() async {
    final response = await http.get(Uri.parse('http://localhost/poc_head/dashboard/fetch_data.php'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print('Fetched data: $data');
      return data;
    } else {
      print('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }
}
