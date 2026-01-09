import 'package:flutter/material.dart';
import '/database_workhorse.dart';
import '/models/menu_items.dart';
import '/models/custom_classes.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE0C8),
      appBar: CafeteAppbar(title: 'About us'),

      body:
      SingleChildScrollView(
        child: Container(
      child: FutureBuilder<String>(
          future: fetchAboutUs(), // hier die Funktion aufrufen
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Fehler beim Laden: ${snapshot.error}'));
            } else {
              // snapshot.data ist dein Text
              return Padding(padding: EdgeInsets.all(16.0),
                child : Text(
                snapshot.data ?? '',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                ),
              ),
            );
            }
          },
        ),
      ),
      )

    );
  }
}