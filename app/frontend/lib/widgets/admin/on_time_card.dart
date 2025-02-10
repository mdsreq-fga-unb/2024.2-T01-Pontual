import 'package:flutter/material.dart';

class OnTimeCard extends StatefulWidget {
  const OnTimeCard({
    super.key,
    required this.turma,
    required this.name,
    required this.delay,
    required this.time,
  });

  final String turma;
  final String name;
  final String time;
  final int delay;

  @override
  State<OnTimeCard> createState() => _OnTimeCardState();
}

class _OnTimeCardState extends State<OnTimeCard> {
  Widget buildDelayText() {
    String prefix = widget.delay > 0 ? "+" : "";
    return Text(
      "$prefix${widget.delay} min",
      style: TextStyle(
        color: Color(0xFF445668),
        fontSize: 8,
      ),
    );
  }

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
                buildDelayText(),
                SizedBox(width: 10),
                Text(
                  "${widget.time}",
                  style: TextStyle(
                    color: Color(0xFF445668),
                    fontSize: 16,
                    fontWeight: FontWeight.w100,
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
