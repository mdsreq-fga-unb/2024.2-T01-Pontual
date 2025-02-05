import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReportButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: Icon(
        Icons.add_circle_outline_sharp,
        size: 20,
        color: Colors.white,
      ),
      label: Text("Gerar Relatório", style: TextStyle(fontSize: 16)),
    );
  }
}
