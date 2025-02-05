import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class AdminUseBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      items: const [
        Icon(Icons.home, color: Colors.white),
        Icon(
          Icons.fact_check_outlined,
          color: Colors.white,
        ),
        Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ],
      buttonBackgroundColor: Color(0xFFF08484),
      index: 1,
      backgroundColor: Color(0xFFEDEDED),
      color: Color(0xFFF08484),
    );
  }
}
