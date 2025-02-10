import 'package:flutter/material.dart';
import 'package:frontend/utils/dialog_functions.dart';

class DialogOptions extends StatelessWidget {
  final void Function() updateClasses;
  final void Function() updateVIP;

  const DialogOptions({super.key, required this.updateClasses, required this.updateVIP});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Garante que o clique fora funcione
        onTap: () =>
            Navigator.of(context).pop(), // Fecha o diálogo ao clicar fora
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Impede que o clique dentro do diálogo feche ele
            child: Center(
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
                        onPressed: () =>
                            showDialogReposicao(context, updateClasses),
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
                        onPressed: () => showDialogVip(context, updateVIP),
                        child: Text(
                          "Turma VIP",
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
            ),
          ),
        ),
      ),
    );
  }
}
