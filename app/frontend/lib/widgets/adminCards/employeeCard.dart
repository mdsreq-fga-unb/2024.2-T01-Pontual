import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({super.key, required this.name, required this.classes});

  final String name;
  final int classes;

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
                  "${name}",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 11),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "${classes} Turmas cadastradas",
                      style: TextStyle(fontSize: 8, color: Color(0xFF445668)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_circle_right_outlined),
                      color: Color(0xFF2DA5D0),
                      iconSize: 25,
                      padding: EdgeInsets.zero, // Remove padding extra
                      constraints: BoxConstraints(), // Evita restrições extras
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
