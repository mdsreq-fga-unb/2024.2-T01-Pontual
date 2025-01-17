import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class UseBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      items: const [
        Icon(Icons.home, color: Colors.white),
        Text('+',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Icon(
          Icons.person_rounded,
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
