import 'package:flutter/material.dart';

class DialogInputs extends StatelessWidget {
  const DialogInputs({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Garante que o clique fora funcione
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Center(
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(27)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF060606)),
                      ),
                    ),
                    child,
                    Container(
                        width: 350,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: Color(0XFFA5A5A5), width: 0.8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                        color: Color(0XFFA5A5A5), width: 0.8),
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Confirmar",
                                    style: TextStyle(
                                        color: Color(0xFF407FC8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      color: Color(0xFF407FC8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w100),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
