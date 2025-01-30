import 'package:flutter/material.dart';

class DialogOptions extends StatelessWidget {
  const DialogOptions({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(27),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Cadastrar",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF060606)),
              ),
            ),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0XFFA5A5A5), width: 0.8),
                ),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Turma de Reposição",
                  style: TextStyle(
                      color: Color(0xFF407FC8),
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                ),
              ),
            ),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0XFFA5A5A5), width: 0.8),
                ),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Turma de VIP",
                  style: TextStyle(
                      color: Color(0xFF407FC8),
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
