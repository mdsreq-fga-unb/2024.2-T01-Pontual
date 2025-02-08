import 'package:flutter/material.dart';

class EmployeeReportCard extends StatefulWidget {
  const EmployeeReportCard(
      {super.key,
      required this.date,
      required this.name,
      required this.hours,
      required this.lateTime,
      required this.missing,
      required this.reviewed});

  final String date;
  final String name;
  final int hours;
  final String lateTime;
  final int missing;
  final bool reviewed;

  @override
  State<EmployeeReportCard> createState() => _EmployeeReportCardState();
}

class _EmployeeReportCardState extends State<EmployeeReportCard> {
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
                  widget.date,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Horas: ${widget.hours}h",
                      style: TextStyle(color: Color(0xFF445668), fontSize: 6),
                    ),
                    Text(
                      "Atraso: +${widget.lateTime}",
                      style: TextStyle(color: Color(0xFF445668), fontSize: 6),
                    ),
                    Text(
                      "Faltas: ${widget.missing}",
                      style: TextStyle(color: Color(0xFF445668), fontSize: 6),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    selectIcons(widget.reviewed),
                    Text(
                      (widget.reviewed ? "Revisado" : "Não Revisado"),
                      style: TextStyle(color: Color(0xFF445668), fontSize: 5),
                    )
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => {},
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

Widget selectIcons(reviewed) {
  if (reviewed == true) {
    return Icon(
      Icons.check,
      color: Colors.green,
      size: 16,
    );
  } else {
    return Icon(
      Icons.close,
      color: Colors.red,
      size: 16,
    );
  }
}
