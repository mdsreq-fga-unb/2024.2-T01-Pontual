import 'package:flutter/material.dart';
import 'package:frontend/api/classes_handler.dart';
import 'package:frontend/api/status_handler.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/dialog_inputs.dart';
import 'package:frontend/widgets/dropdown_menu.dart';
import 'package:provider/provider.dart';

DateTime combineDateAndTime(DateTime date, TimeOfDay timeOfDay) {
  // Combine the year, month, and day of the DateTime with the hour and minute of the TimeOfDay
  return DateTime(
    date.year,
    date.month,
    date.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );
}

String getWeekdayText(int weekday) {
  List<String> weekdays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
  return weekdays[weekday];
}

String getClassAsString(dynamic value) {
  String days = "";
  for (var j = 0; j < value["days"].length; j++) {
    days += getWeekdayText(value["days"][j]);
    if (j != value["days"].length - 1) {
      days += ", ";
    }
  }
  String begin = "${value["name"]} ($days)";
  String cls = "$begin - ${value["start_time"].substring(0, 5)}";

  return cls;
}

List<dynamic> updateDateTimeAndTimeOfDay(
  DateTime dateTime,
  TimeOfDay timeOfDay,
  int minutes,
) {
  final hourAdd = (timeOfDay.minute + minutes) >= 60 ? 1 : 0;

  final updatedTimeOfDay = TimeOfDay(
    hour: (timeOfDay.hour + hourAdd + 1) % 24,
    minute: (timeOfDay.minute + minutes) % 60,
  );

  DateTime updatedDateTime = dateTime;
  if (updatedTimeOfDay.hour == 0 && timeOfDay.hour == 23) {
    updatedDateTime = updatedDateTime.add(Duration(days: 1));
  }

  return [updatedDateTime, updatedTimeOfDay];
}

void showDialogReposicao(BuildContext context, void Function() updateClasses) {
  Navigator.of(context).pop();

  Future.microtask(() async {
    DateTime? selectedDate;
    TimeOfDay? selectedEntrada;
    TimeOfDay? selectedSaida;

    DateTime today = DateTime.now();
    DateTime startRange = today.subtract(Duration(days: 30));

    String startYear = startRange.year.toString().padLeft(2, "0");
    String startMonth = startRange.month.toString().padLeft(2, "0");
    String startDay = startRange.day.toString().padLeft(2, "0");

    String selectedClass = "";
    List<String> classes = [];
    Map<String, int> classesId = {};

    await ClassesHandler()
        .getByStart("$startYear-$startMonth-${startDay}T00:00:00",
            context.read<UserProvider>().accessToken)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        String cls = getClassAsString(value[i]);
        if (i == 0) {
          selectedClass = cls;
        }

        classes.add(cls);
        classesId[cls] = value[i]["id"];
      }
    }).catchError((error) {});

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
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                            "O horário de saída deve ser maior que o de entrada."),
                        backgroundColor: Colors.red,
                        margin: EdgeInsets.only(
                          bottom: 55,
                        ),
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
              onConfirm: () {
                if (selectedDate != null &&
                    selectedEntrada != null &&
                    selectedSaida != null &&
                    selectedClass != "") {
                  StatusHandler()
                      .post(
                          null,
                          classesId[selectedClass]!,
                          "rep",
                          combineDateAndTime((selectedDate as DateTime),
                              (selectedEntrada as TimeOfDay)),
                          combineDateAndTime((selectedDate as DateTime),
                              (selectedSaida as TimeOfDay)),
                          context.read<UserProvider>().accessToken)
                      .then((value) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Aula de reposição cadastrada!"),
                        backgroundColor: Colors.lightGreen,
                        margin: EdgeInsets.only(
                          bottom: 55,
                        ),
                      ),
                    );
                    updateClasses();
                  }).catchError((error) {});
                }
              },
              title: 'Cadastrar Reposição',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Turma"),
                  ),
                  Center(
                      child: DropdownMenuCustom(
                    list: classes,
                    onChanged: (String? value) {
                      selectedClass = value!;
                    },
                  )),
                  SizedBox(height: 10),
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

void showDialogVip(BuildContext context, void Function() updateClasses) {
  Navigator.of(context).pop();

  Future.microtask(() {
    String selectedClassType = "Infantil";

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
              onConfirm: () {
                if (selectedDate != null && selectedEntrada != null) {
                  final [endSelectedDate, selectedOut] =
                      updateDateTimeAndTimeOfDay(
                    (selectedDate as DateTime),
                    (selectedEntrada as TimeOfDay),
                    selectedClassType == "Infantil" ? 0 : 15,
                  );

                  StatusHandler()
                      .post(
                          context.read<UserProvider>().uuid,
                          null,
                          "vip",
                          combineDateAndTime((selectedDate as DateTime),
                              (selectedEntrada as TimeOfDay)),
                          combineDateAndTime((endSelectedDate as DateTime),
                              (selectedOut as TimeOfDay)),
                          context.read<UserProvider>().accessToken)
                      .then((value) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Aula VIP cadastrada!"),
                        backgroundColor: Colors.lightGreen,
                        margin: EdgeInsets.only(
                          bottom: 55,
                        ),
                      ),
                    );
                    updateClasses();
                  }).catchError((error) {});
                }
              },
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
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text("Tipo de Aula"),
                  ),
                  Center(
                    child: DropdownMenuCustom(
                        list: ["Infantil", "Adulto"],
                        onChanged: (String? value) {
                          selectedClassType = value!;
                        }),
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

void showDialogHour(
    BuildContext context, Function confirm, String title, bool isEntry) {
  Future.microtask(() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogInputs(
          onConfirm: () => confirm(),
          title: title,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
                "Deseja registrar esse horário como de ${isEntry ? "entrada" : "saída"}?"),
          ),
        );
      },
    );
  });
}

void showDialogReport(BuildContext context, Function(String, String) confirm) {
  Future.microtask(() {
    DateTime? selectedDateBegin;
    DateTime? selectedDateEnd;
    String errorInfo = "";

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
                firstDate: selectedDateBegin ?? DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                if (picked.isAfter(DateTime.now())) {
                  setState(() {
                    errorInfo = "A data final não pode ser no futuro.";
                  });
                } else {
                  setState(() {
                    selectedDateEnd = picked;
                    errorInfo = "";
                  });
                }
              }
            }

            return DialogInputs(
              onConfirm: () => confirm(
                  "${selectedDateBegin!.year}-${selectedDateBegin!.month.toString().padLeft(2, "0")}-${selectedDateBegin!.day.toString().padLeft(2, "0")}",
                  "${selectedDateEnd!.year}-${selectedDateEnd!.month.toString().padLeft(2, "0")}-${selectedDateEnd!.day.toString().padLeft(2, "0")}"),
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Text(
                      errorInfo,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  });
}

void showDialogNewClass(
    BuildContext context, String uuid, void Function() update) {
  Future.microtask(() {
    final List<String> diasDaSemana = [
      "Domingo",
      "Segunda",
      "Terça",
      "Quarta",
      "Quinta",
      "Sexta",
      "Sábado",
    ];

    DateTime? selectedDate;
    DateTime? selectedDateFinal;
    TimeOfDay? selectedEntrada;
    String? selectedFaixaEtaria;
    List<String> selectedDiasDaSemana = [];
    TextEditingController nameController = TextEditingController();

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

            void _selectDiasDaSemana() async {
              List<String> selectedDays = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  List<String> selection = List.from(selectedDiasDaSemana);

                  return StatefulBuilder(
                    builder: (context, setStateDialog) {
                      return SimpleDialog(
                        title: Text("Selecione os Dias da Semana"),
                        children: [
                          ...diasDaSemana.map((dia) {
                            return SimpleDialogOption(
                              onPressed: () {
                                setStateDialog(() {
                                  if (selection.contains(dia)) {
                                    selection.remove(dia);
                                  } else {
                                    selection.add(dia);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: selection.contains(dia),
                                    onChanged: (bool? selected) {
                                      setStateDialog(() {
                                        if (selected ?? false) {
                                          selection.add(dia);
                                        } else {
                                          selection.remove(dia);
                                        }
                                      });
                                    },
                                  ),
                                  Text(dia),
                                ],
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, selection);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Confirmar",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0F759A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              );

              setState(() {
                selectedDiasDaSemana = selectedDays;
                selectedDiasDaSemana.sort((a, b) {
                  return diasDaSemana
                      .indexOf(a)
                      .compareTo(diasDaSemana.indexOf(b));
                });
              });
            }

            return DialogInputs(
              onConfirm: () {
                if (nameController.text.isEmpty ||
                    selectedDiasDaSemana.isEmpty ||
                    selectedDate == null ||
                    selectedDateFinal == null ||
                    selectedEntrada == null ||
                    selectedFaixaEtaria == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("Preencha todos os campos."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                String startTime =
                    "${selectedEntrada!.hour.toString().padLeft(2, '0')}:${selectedEntrada!.minute.toString().padLeft(2, '0')}:00";

                String endTime;
                if (selectedFaixaEtaria == "Infantil") {
                  endTime =
                      "${((selectedEntrada!.hour + 1) % 24).toString().padLeft(2, "0")}:${selectedEntrada!.minute.toString().padLeft(2, '0')}:00";
                } else {
                  final minutes = selectedEntrada!.minute + 15;
                  endTime =
                      "${((selectedEntrada!.hour + 1 + (minutes >= 60 ? 1 : 0)) % 24).toString().padLeft(2, "0")}:${(minutes % 60).toString().padLeft(2, '0')}:00";
                }

                ClassesHandler()
                    .post(context.read<UserProvider>().accessToken, {
                  "name": nameController.text,
                  "days": selectedDiasDaSemana
                      .map((item) => diasDaSemana.indexOf(item))
                      .toList(),
                  "start_range": selectedDate!.toIso8601String(),
                  "end_range": DateTime(
                    selectedDateFinal!.year,
                    selectedDateFinal!.month,
                    selectedDateFinal!.day,
                    23,
                    59,
                    59,
                  ).toIso8601String(),
                  "start_time": startTime,
                  "end_time": endTime,
                  "user": uuid,
                }).then((value) {
                  update();
                  Navigator.of(context).pop();
                }).catchError((error) {});
              },
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
                              controller: nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Digite aqui...",
                                hintStyle: TextStyle(color: Color(0xFFAFAFAF)),
                                contentPadding: EdgeInsets.only(bottom: 18),
                              ),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 9),
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
                        onTap: _selectDiasDaSemana,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDiasDaSemana.isEmpty
                                  ? "Selecionar dias"
                                  : selectedDiasDaSemana
                                      .map((item) => item.substring(0, 3))
                                      .join(', '),
                              style: TextStyle(fontSize: 9),
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
                              style: TextStyle(fontSize: 9),
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
                        style: TextStyle(fontSize: 9, color: Colors.black),
                        underline: SizedBox(), // remove a linha embaixo
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFaixaEtaria = newValue;
                          });
                        },
                        items: <String>['Infantil', 'Adulto']
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
                              style: TextStyle(fontSize: 9),
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
                              style: TextStyle(fontSize: 9),
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
