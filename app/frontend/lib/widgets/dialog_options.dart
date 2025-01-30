import 'package:flutter/material.dart';
import 'package:frontend/widgets/dialog_inputs.dart';

class DialogOptions extends StatelessWidget {
  const DialogOptions({super.key});

  void _showDialogReposicao(BuildContext context) {
    DateTime? selectedDate;
    TimeOfDay? selectedEntrada;
    TimeOfDay? selectedSaida;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _selectDate() async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
              }
            }

            Future<void> _selectEntrada() async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: selectedEntrada ?? TimeOfDay.now(),
              );
              if (picked != null && picked != selectedEntrada) {
                setState(() {
                  selectedEntrada = picked;
                });
              }
            }

            Future<void> _selectSaida() async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: selectedSaida ?? TimeOfDay.now(),
              );
              if (picked != null) {
                if (selectedEntrada != null) {
                  final int entradaMinutos =
                      selectedEntrada!.hour * 60 + selectedEntrada!.minute;
                  final int saidaMinutos = picked.hour * 60 + picked.minute;

                  if (saidaMinutos <= entradaMinutos) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "O horário de saída deve ser maior que o de entrada."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                }
                setState(() {
                  selectedSaida = picked;
                });
              }
            }

            return DialogInputs(
              title: 'Cadastrar Reposição',
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha os textos à esquerda
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 12), // Alinha o texto com o input
                    child: Text("Data"),
                  ),
                  Center(
                    // Centraliza o input
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      width: 290,
                      height: 27,
                      decoration: BoxDecoration(
                        color: Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: GestureDetector(
                        onTap: _selectDate,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? "Selecionar data"
                                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              style: TextStyle(fontSize: 10),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Color(0xFFAFAFAF),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 12), // Alinha o texto com o input
                    child: Text("Entrada"),
                  ),
                  Center(
                    // Centraliza o input
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      width: 290,
                      height: 27,
                      decoration: BoxDecoration(
                        color: Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: GestureDetector(
                        onTap: _selectEntrada,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedEntrada == null
                                  ? "Selecionar horário"
                                  : "${selectedEntrada!.hour.toString().padLeft(2, '0')}:${selectedEntrada!.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(fontSize: 10),
                            ),
                            Icon(
                              Icons.access_time,
                              color: Color(0xFFAFAFAF),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 12), // Alinha o texto com o input
                    child: Text("Saída"),
                  ),
                  Center(
                    // Centraliza o input
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      width: 290,
                      height: 27,
                      decoration: BoxDecoration(
                        color: Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: GestureDetector(
                        onTap: _selectSaida,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedSaida == null
                                  ? "Selecionar horário"
                                  : "${selectedSaida!.hour.toString().padLeft(2, '0')}:${selectedSaida!.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(fontSize: 10),
                            ),
                            Icon(
                              Icons.access_time,
                              color: Color(0xFFAFAFAF),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
                        onPressed: () => _showDialogReposicao(context),
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
            ),
          ),
        ),
      ),
    );
  }
}
