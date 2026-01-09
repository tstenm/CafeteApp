import 'package:flutter/material.dart';
import '../models/menu_items.dart';
import 'menu_page.dart';
import 'news_page.dart';
import '/models/opening_hours_model.dart';
import '/database_workhorse.dart';
import '/models/italian_font.dart';


class Test extends StatefulWidget {

  //Todo : News aus der Datenbank holen, an Customwidget übergeben
  @override
  _State createState() => _State();
}

class _State extends State<Test> {

  final List<String> entries = <String> ["News der Woche"];
  late List<News> listnews = [];
  @override
  void initState() {
    super.initState();
    loadNews();
  }

  void loadNews() async {
    try {
      final fetchedNews = await fetchNews();
      setState(() {
        listnews = fetchedNews;
      });
    } catch (e) {
      print('Fehler beim Laden der News: $e');

  }}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment(-0.3, 0),
          child: Text(
            'News',
            style: TextStyle(
              fontSize: 28,         // groß
              fontWeight: FontWeight.bold, // fett
              color: Colors.white,  // weiß
            ),
          ),
        ),
        backgroundColor: const Color(0xFF4B3621),
      ),
      body:  Container(
        color:  const Color(0xFFEDE0C8),
        child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: listnews.length,
            itemBuilder: (BuildContext context, int index) {
        return  Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Card(
              margin: EdgeInsets.zero,
              color: Color(0xFF4B3621),
              child: ExpansionTile(
                title: Center(
                  child: Text(
                    listnews[index].title!,
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    listnews[index].formattedDate,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                collapsedBackgroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                textColor: Colors.white,
                children: [
                  Container(
                    color: Color(0xFFEDE0C8),
                    child: ListTile(title: Text(listnews[index].news!)),
                  ),
                ],
              ),
            ),
          ),
        );
            }
            ),
      )
    );
}
}

