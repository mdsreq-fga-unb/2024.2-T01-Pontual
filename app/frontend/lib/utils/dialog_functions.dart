import 'package:flutter/material.dart';
import 'package:frontend/widgets/dialog/dialog_inputs.dart';

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

void showDialogNewClass(BuildContext context) {
  Navigator.of(context).pop(); // Fecha o primeiro diálogo

  Future.microtask(() {
    DateTime? selectedDate; // Data inicial
    DateTime? selectedDateFinal; // Data final
    TimeOfDay? selectedEntrada;
    String? selectedFaixaEtaria;
    List<String> selectedDiasDaSemana = [];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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

            // Função para abrir o Dialog de dias da semana
            void _selectDiasDaSemana() async {
              List<String> diasDaSemana = [
                "Segunda-feira",
                "Terça-feira",
                "Quarta-feira",
                "Quinta-feira",
                "Sexta-feira",
                "Sábado",
                "Domingo"
              ];

              final List<String> diasSelecionados = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text("Selecione os Dias da Semana"),
                    children: diasDaSemana.map((dia) {
                      return SimpleDialogOption(
                        onPressed: () {
                          if (selectedDiasDaSemana.contains(dia)) {
                            selectedDiasDaSemana.remove(dia);
                          } else {
                            selectedDiasDaSemana.add(dia);
                          }
                          Navigator.pop(context, selectedDiasDaSemana);
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: selectedDiasDaSemana.contains(dia),
                              onChanged: (bool? selected) {
                                if (selected != null && selected) {
                                  selectedDiasDaSemana.add(dia);
                                } else {
                                  selectedDiasDaSemana.remove(dia);
                                }
                                Navigator.pop(context, selectedDiasDaSemana);
                              },
                            ),
                            Text(dia),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              );

              setState(() {
                selectedDiasDaSemana = diasSelecionados;
              });
            }

            return DialogInputs(
              title: 'Cadastrar Turma',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Nome da Aula"),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: 290,
                      height: 27,
                      decoration: BoxDecoration(
                        color: Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Digite aqui...",
                                hintStyle: TextStyle(color: Color(0xFFAFAFAF)),
                                contentPadding: EdgeInsets.only(bottom: 14),
                              ),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_alt_outlined,
                            color: Color(0xFFAFAFAF),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Dias da Semana"),
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
                        onTap: _selectDiasDaSemana, // Abre o dialog de dias
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDiasDaSemana.isEmpty
                                  ? "Selecionar dias"
                                  : selectedDiasDaSemana.join(', '),
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
                    child: Text("Horário de Entrada"),
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
                    child: Text("Tipo"),
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
                      child: DropdownButton<String>(
                        value:
                            selectedFaixaEtaria, // variável para armazenar a seleção
                        hint: Text("Selecione"),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down,
                            color: Color(0xFFAFAFAF)),
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        underline: SizedBox(), // remove a linha embaixo
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFaixaEtaria = newValue;
                          });
                        },
                        items: <String>['Infantil', 'Jovem', 'Adulto', 'Misto']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Data de Início"),
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
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null &&
                              pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? "Selecione a data"
                                  : "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}",
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
                        onTap: () async {
                          // Se selectedDateFinal já estiver definido, permite selecionar a data final com base na data inicial
                          DateTime firstSelectableDate =
                              selectedDate ?? DateTime.now();

                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDateFinal ??
                                firstSelectableDate, // Usa a data final se já houver uma, caso contrário usa a data inicial ou hoje
                            firstDate:
                                firstSelectableDate, // Impede selecionar uma data anterior à data inicial
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null &&
                              pickedDate != selectedDateFinal) {
                            setState(() {
                              selectedDateFinal = pickedDate;
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDateFinal == null
                                  ? "Selecione a data final"
                                  : "${selectedDateFinal!.day.toString().padLeft(2, '0')}/${selectedDateFinal!.month.toString().padLeft(2, '0')}/${selectedDateFinal!.year}",
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
                ],
              ),
            );
          },
        );
      },
    );
  });
}


void showDialogEditClass(BuildContext context) {

  



  Future.microtask(() {
    DateTime? selectedDate;
    DateTime? selectedDateFinal;
    TimeOfDay? selectedEntrada = TimeOfDay(hour: 7, minute: 0);
    String? selectedFaixaEtaria = "Infantil";
    List<String> selectedDiasDaSemana = ["Segunda", "Quarta", "Sexta"];
    TextEditingController nomeController =
        TextEditingController(text: "Gramática");

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
              title: 'Editar Turma',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Nome da Aula"),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      width: 290,
                      height: 27,
                      decoration: BoxDecoration(
                        color: Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nomeController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Digite aqui...",
                                hintStyle: TextStyle(color: Color(0xFFAFAFAF)),
                                contentPadding: EdgeInsets.only(bottom: 14),
                              ),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_alt_outlined,
                            color: Color(0xFFAFAFAF),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Dias da Semana"),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      width: 290,
                      height: 27,
                      decoration: BoxDecoration(
                        color: Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDiasDaSemana.join(', '),
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
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Horário de Entrada"),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
                              "${selectedEntrada!.hour.toString().padLeft(2, '0')}:${selectedEntrada!.minute.toString().padLeft(2, '0')}",
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
                    child: Text("Tipo de Aula"),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      width: 290,
                      height: 27,
                      decoration: BoxDecoration(
                        color: Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: selectedFaixaEtaria,
                        hint: Text("Selecione"),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Color(0xFFAFAFAF)),
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        underline: SizedBox(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFaixaEtaria = newValue;
                          });
                        },
                        items: <String>['Infantil', 'Regular', 'VIP']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Data de Início"),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      width: 290,
                      height: 27,
                      decoration: BoxDecoration(
                        color: Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text("Quarta-feira, 4 de dezembro de 2023",
                          style: TextStyle(fontSize: 10)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Data de Fim"),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      width: 290,
                      height: 27,
                      decoration: BoxDecoration(
                        color: Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text("Quarta-feira, 4 de dezembro de 2024",
                          style: TextStyle(fontSize: 10)),
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
