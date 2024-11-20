import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryService {
  static Future<List<Map<String, dynamic>>> fetchCountries() async {
    final response = await http.get(
        Uri.parse('https://medicalpoint-api.tatwer.tech/api/Login/GetCountries')
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => {
        'id': item['code'],  // Ensure the 'id' is unique for each country
        'name': item['name'],
      }).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
