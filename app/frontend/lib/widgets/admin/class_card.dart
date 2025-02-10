import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({
    super.key,
    required this.name,
    required this.days,
    required this.beginTime,
    required this.endTime,
    required this.durationBegin,
    required this.durationEnd,
    required this.canDelete,
    required this.onDelete,
  });

  final bool canDelete;
  final Function onDelete;

  final String name;
  final String days;
  final String beginTime;
  final String endTime;
  final String durationBegin;
  final String durationEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 90,
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
                  name,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Dias: $days",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 10),
                ),
                Text(
                  "Horário: $beginTime - $endTime",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 10),
                ),
                Text(
                  "Duração: $durationBegin - $durationEnd",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 10),
                ),
              ],
            ),
          ),
          canDelete
              ? Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => onDelete(),
                        icon: Icon(Icons.close),
                        color: Color(0xFFBB3901),
                        iconSize: 27,
                        padding: EdgeInsets.zero, // Remove padding extra
                        constraints:
                            BoxConstraints(), // Evita restrições extras
                      ),
                      Text(
                        "Excluir",
                        style: TextStyle(
                          color: Color(0xFF445668),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
