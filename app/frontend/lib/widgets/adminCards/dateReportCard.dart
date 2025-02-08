import 'package:flutter/material.dart';

class DateReportCard extends StatelessWidget {
  const DateReportCard(
      {super.key,
      required this.dateBegin,
      required this.dateEnd,
      required this.onPressed});

  final String dateBegin;
  final String dateEnd;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 42,
      width: 370,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${dateBegin} - ${dateEnd}",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(Icons.arrow_circle_right_outlined),
                  color: Color(0xFF2DA5D0),
                  iconSize: 25,
                  padding: EdgeInsets.zero, // Remove padding extra
                  constraints: BoxConstraints(), // Evita restrições extras
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
