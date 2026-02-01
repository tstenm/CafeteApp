import 'package:flutter/material.dart';


class CafeteAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CafeteAppbar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Align(
        alignment: const Alignment(-0.3, 0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF4B3621),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
class customHomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const customHomePageAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Center(
        child: Baseline(
          baseline: 30,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            'Cafete',
            style: TextStyle(
              fontSize: 28,         // groß
              fontWeight: FontWeight.bold, // fett
              color: Colors.white,  // weiß
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF4B3621),
    );
  }
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}
