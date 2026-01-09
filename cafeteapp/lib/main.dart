import 'package:flutter/material.dart';
import '/routes/routes.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meine App',
      initialRoute: AppRoutes.home,   // Startseite
      routes: AppRoutes.getRoutes(),  // zentrale Routen
    );
  }
}
