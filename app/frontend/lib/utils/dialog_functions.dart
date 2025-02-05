import 'package:flutter/material.dart';
import 'package:frontend/widgets/dialog_inputs.dart';

void showDialogReposicao(BuildContext context) {
  Navigator.of(context).pop(); // Fecha o primeiro diálogo

  Future.microtask(() {
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
              if (picked != null) {
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
              if (picked != null) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Data"),
                  ),
                  Center(
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
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Entrada"),
                  ),
                  Center(
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
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Saída"),
                  ),
                  Center(
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
  });
}

void showDialogVip(BuildContext context) {
  Navigator.of(context).pop(); // Fecha o primeiro diálogo

  Future.microtask(() {
    DateTime? selectedDate;
    TimeOfDay? selectedEntrada;

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
              if (picked != null) {
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
              if (picked != null) {
                setState(() {
                  selectedEntrada = picked;
                });
              }
            }

            return DialogInputs(
              title: 'Cadastrar VIP',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Data"),
                  ),
                  Center(
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
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Horário"),
                  ),
                  Center(
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
                ],
              ),
            );
          },
        );
      },
    );
  });
}

void showDialogReport(BuildContext context) {
  Navigator.of(context).pop(); // Fecha o primeiro diálogo

  Future.microtask(() {
    DateTime? selectedDateBegin;
    DateTime? selectedDateEnd;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _selectDateBegin() async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDateBegin ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                setState(() {
                  selectedDateBegin = picked;
                });
              }
            }

            Future<void> _selectDateEnd() async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDateBegin ?? DateTime.now(),
                firstDate: selectedDateBegin ??
                    DateTime(
                        2000), // Garante que a data final não seja menor que a inicial
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                setState(() {
                  selectedDateEnd = picked;
                });
              }
            }

            return DialogInputs(
              title: 'Gerar Relatório de Registro de Ponto',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Data Inicial"),
                  ),
                  Center(
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
                        onTap: _selectDateBegin,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDateBegin == null
                                  ? "Selecionar data"
                                  : "${selectedDateBegin!.day}/${selectedDateBegin!.month}/${selectedDateBegin!.year}",
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
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Data Final"),
                  ),
                  Center(
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
                        onTap: _selectDateEnd,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDateEnd == null
                                  ? "Selecionar data"
                                  : "${selectedDateEnd!.day}/${selectedDateEnd!.month}/${selectedDateEnd!.year}",
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
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  });
}
