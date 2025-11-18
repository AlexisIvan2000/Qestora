import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_end/services/auth_service.dart';

class EventService {
  static Future<List<dynamic>> fetchEvents() async {
    final url = Uri.parse("${Api.baseUrl}/events/");

    final headers = await AuthService.getAuthHeader();

    final res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Erreur API Ticketmaster");
    }
  }
}