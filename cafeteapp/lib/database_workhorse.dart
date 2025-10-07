import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/menu_items.dart';
import '/database_workhorse.dart';
import 'dart:io'; // für HttpDate

String backendBaseUrl = 'http://51.20.239.69:5000';
//String backendBaseUrl = 'http://192.168.48.87:5000/';     //nur für Heute



// Endpoints dynamisch aus der Basis-URL bauen
String get backendMenuUrl => '$backendBaseUrl/menu';
String get backendActiveUrl => '$backendBaseUrl/active';
String get backendNewsUrl => '$backendBaseUrl/news';

// Prüft, ob das Backend erreichbar ist (beide Endpoints)
Future<bool> checkConnection() async {

  try {
    final responseMenu = await http.get(Uri.parse(backendMenuUrl)).timeout(Duration(seconds: 5));
    final responseActive = await http.get(Uri.parse(backendActiveUrl)).timeout(Duration(seconds: 5));

    if (responseMenu.statusCode == 200 && responseActive.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Fehler bei Verbindung zum Backend: $e');
    return false;
  }
}

// Menü-Daten abrufen
Future<List<MenuItem>> fetchMenu() async {
  try {
    final response = await http.get(Uri.parse(backendMenuUrl)).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => MenuItem.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Server antwortet mit Fehlercode ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Keine Verbindung zum Backend');
  } 
}

// Active-Daten abrufen
Future<Active> fetchActive() async {
  final response = await http.get(Uri.parse(backendActiveUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return Active.fromJson(data[0] as Map<String, dynamic>); // erstes Element der Liste
  } else {
    throw Exception('Failed to load active');
  }
}

// News-Daten abrufen
Future<List<News>> fetchNews() async {
  try {
    final response = await http.get(Uri.parse(backendNewsUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => News.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Server antwortet mit Fehlercode ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Keine Verbindung zum Backend');
  }
}
