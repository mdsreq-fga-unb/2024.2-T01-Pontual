import 'package:flutter/material.dart';

class Latecard extends StatefulWidget {
  const Latecard(
      {super.key, required this.turma, required this.name, required this.time});

  final String turma;
  final String name;
  final int time;

  @override
  State<Latecard> createState() => _LatecardState();
}

class _LatecardState extends State<Latecard> {
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
                  widget.turma,
                  style: TextStyle(color: Color(0xFF445668), fontSize: 10),
                ),
                Text(
                  widget.name,
                  style: TextStyle(color: Colors.black, fontSize: 11),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text(
                  "${widget.time} min",
                  style: TextStyle(color: Color(0xFF445668), fontSize: 16),
                ),
                SizedBox(width: 10),
                SizedBox(
                  height: 32, // Limitando a altura da Column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.chat_bubble_outline_outlined),
                        color: Color(0xFF2DA5D0),
                        iconSize: 20,
                        padding: EdgeInsets.zero, // Remove padding extra
                        constraints:
                            BoxConstraints(), // Evita restrições extras
                      ),
                      Text(
                        "Notificação",
                        style: TextStyle(
                          color: Color(0xFF2DA5D0),
                          fontSize: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
