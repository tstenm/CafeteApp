import 'package:flutter/material.dart';
import '/database_workhorse.dart';
import '/models/menu_items.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Sofort mit leerer Future initialisieren, um LateInitializationError zu vermeiden
  late Future<List<MenuItem>> menuItems = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  // Verbindung prüfen und Menü laden
  void _loadMenu() async {
    bool connected = await checkConnection();
    if (connected) {
      setState(() {
        menuItems = fetchMenu();
      });
    } else {
      setState(() {
        menuItems = Future.error('Keine Verbindung zum Backend');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment(-0.3, 0),
          child: Baseline(
            baseline: 30, // Pixelhöhe anpassen
            baselineType: TextBaseline.alphabetic,
            child: const Text(
              'Menu',
              style: TextStyle(
                fontFamily: 'italian',
                color: Colors.black,
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF4B3621),
      ),
      body: Container(
        color: const Color(0xFFEDE0C8),
        child: FutureBuilder<List<MenuItem>>(
          future: menuItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Fehler: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Keine Menüeinträge vorhanden'));
            } else {
              final items = snapshot.data!;

              // Items nach Kategorie gruppieren
              Map<String, List<MenuItem>> groupedItems = {};
              for (var item in items) {
                groupedItems.putIfAbsent(item.category, () => []).add(item);
              }

              // Innerhalb Kategorie: nach Preis, bei gleichem Preis nach Alphabet sortieren
              for (var entry in groupedItems.entries) {
                entry.value.sort((a, b) {
                  int priceCompare = a.price.compareTo(b.price);
                  return priceCompare != 0 ? priceCompare : a.name.compareTo(b.name);
                });
              }

              // Scrollable Column
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: groupedItems.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              entry.key, // Kategorie-Name
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ...entry.value.map((item) => Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          elevation: 3,
                          color: const Color(0xFF4B3621),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text(
                                    "${item.price.toStringAsFixed(2)} €",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
