import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReportButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2DA5D0),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(
        Icons.add_circle_outline_sharp,
        size: 20,
        color: Colors.white,
      ),
      label: Text(
        "Gerar Relatórios",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}
