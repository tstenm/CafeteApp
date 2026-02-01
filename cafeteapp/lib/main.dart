import 'package:flutter/material.dart';
import '/routes/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;
import 'dart:io';              // <-- für Directory


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(); // lädt automatisch aus Assets

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
