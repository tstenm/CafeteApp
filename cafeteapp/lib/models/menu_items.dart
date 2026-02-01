import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // für HttpDate.parse
import '/database_workhorse.dart';


class MenuItem {
  final String name;
  final double price;
  final String category; // neue Kategorie

  MenuItem({required this.name, required this.price, required this.category});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['itemname'] ?? 'Unbekannt',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      category: json['category'] ?? 'Sonstiges',
    );
  }
}

class Active {
  final bool active;

  Active({required this.active});

  factory Active.fromJson(Map<String, dynamic> json) {
    final dynamic rawValue = json['active'];
    int value;

    if (rawValue is int) {
      value = rawValue;
    } else if (rawValue is bool) {
      value = rawValue ? 1 : 0;
    } else if (rawValue is String) {
      value = int.tryParse(rawValue) ?? 0;
    } else {
      value = 0;
    }

    return Active(active: value == 1);
  }
}

class News {
  final DateTime? date;
  final String? news;
  final String? title;

  News({this.date, this.news, this.title});

  factory News.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['date'] != null) {
      try {
        // HTTP-Datum-Format korrekt parsen: "Mon, 15 Sep 2025 00:00:00 GMT"
        parsedDate = HttpDate.parse(json['date'] as String);
      } catch (_) {
        parsedDate = null;
      }
    }

    return News(
      date: parsedDate,
      news: json['news'] as String?,
      title: json['title'] as String?,
    );
  }

  // Null-sicherer Getter für die UI
  String get formattedDate => date != null
      ? "${date!.day.toString().padLeft(2, '0')}.${date!.month.toString().padLeft(2, '0')}.${date!.year}"
      : 'kein Datum';

  String get newsText => news ?? 'kein Text';
  String get titleText => title ?? 'kein Titel';
}

class NewsService {
  static const String backendUrl = 'http://192.168.48.155:5000/news';

  static Future<List<News>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(backendUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((e) => News.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Server antwortet mit Fehlercode ${response.statusCode}');
      }
    } catch (e) {
      print('Fehler beim Laden der News: $e');
      throw Exception('Keine Verbindung zum Backend');
    }
  }
}
