import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';

class EmployeeReportCard extends StatefulWidget {
  const EmployeeReportCard(
      {super.key,
      required this.id,
      required this.name,
      required this.email,
      required this.hours,
      required this.minutes,
      required this.missing,
      required this.reviewed});

  final String name, email;
  final int hours, minutes, id, missing;
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
                  widget.name,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                Text(
                  widget.email,
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
                      "Horas: ${widget.hours}h e ${widget.minutes}m",
                      style: TextStyle(color: Color(0xFF445668), fontSize: 8),
                    ),
                    Text(
                      "Faltas: ${widget.missing}",
                      style: TextStyle(color: Color(0xFF445668), fontSize: 8),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    selectIcons(widget.reviewed),
                    Text(
                      (widget.reviewed ? "Revisado" : "Não Revisado"),
                      style: TextStyle(color: Color(0xFF445668), fontSize: 7),
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
                      onPressed: () {
                        Navigator.of(context).pushNamed("${AppRoutes.Report}/${widget.id}");
                      },
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
