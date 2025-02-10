import 'package:flutter/material.dart';
import 'package:frontend/api/status_handler.dart';
import 'package:frontend/utils/dialog_functions.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/dialog_inputs.dart';
import 'package:frontend/widgets/dropdown_menu.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum Status { waiting, leave, ok, closed }

class TimeCardWidget extends StatelessWidget {
  final int minutesDelayed = 15;

  final int? id;
  final int? statusId;
  final String? statusMessage;
  final String title;
  final String? kind;
  final DateTime startTime, endTime;
  final DateTime? startRegister, endRegister;
  final VoidCallback updateClasses;

  const TimeCardWidget({
    Key? key,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.updateClasses,
    this.id,
    this.kind,
    this.startRegister,
    this.endRegister,
    this.statusId,
    this.statusMessage,
  }) : super(key: key);

  String makeTitle(String str) {
    return str[0].toUpperCase() + str.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    Icon icon;
    Color iconColor;
    String iconStatus;

    String notes = "Esqueceu";
    Status status = Status.waiting;
    Duration difference = DateTime.now().difference(endTime);
    if (startRegister != null) {
      status = Status.leave;
      icon = Icon(Icons.check_circle, size: 32);
      iconColor = Colors.amber;

      DateFormat formatter = DateFormat("dd/MM/yyyy - HH:mm");

      String formattedStartRegister =
          formatter.format(startRegister as DateTime);
      iconStatus = "Entrada em $formattedStartRegister";

      if (endRegister != null) {
        status = Status.ok;
        if (kind == "std" ||
            kind == null ||
            endRegister!.difference(DateTime.now()).inMinutes <= 0) {
          iconColor = Colors.green;

          String formattedEndRegister =
              formatter.format(endRegister as DateTime);
          iconStatus += "\nSaída em $formattedEndRegister";
        } else {
          iconStatus += "\nAguardando Finalização";
        }
      } else {
        iconStatus += "\nAguardando Saída";
      }
    } else if (difference.inMinutes <= minutesDelayed) {
      icon = Icon(Icons.warning_amber_rounded, size: 32);
      iconColor = Colors.amber;
      iconStatus = "Aguardando Registro";
    } else {
      status = Status.closed;
      icon = Icon(Icons.cancel, size: 32);
      iconColor = Colors.red;
      iconStatus = "Ponto não batido";
      if (statusMessage != null) {
        iconStatus = "Justificativa: ${makeTitle(statusMessage as String)}";
      } else {
        iconStatus = "Ponto não batido. Aguardando justificativa!";
      }
    }

    return GestureDetector(
      onTap: () {
        if (status == Status.closed && statusMessage == null) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return DialogInputs(
                onConfirm: () => {
                  if (kind == "std")
                    {
                      StatusHandler()
                          .close(id!, notes, startTime, endTime,
                              context.read<UserProvider>().accessToken)
                          .then((value) {
                        updateClasses();
                        Navigator.of(context).pop();
                      }).catchError((error) {})
                    }
                  else
                    {
                      StatusHandler()
                          .patch(statusId!, null, null, notes,
                              context.read<UserProvider>().accessToken)
                          .then((value) {
                        updateClasses();
                        Navigator.of(context).pop();
                      }).catchError((error) {})
                    }
                },
                title: title,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Selecione o motivo do ponto não batido:"),
                      DropdownMenuCustom(
                          list: ["Esqueceu", "Faltou", "Atestado"],
                          onChanged: (String? value) {
                            notes = value as String;
                          }),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (status == Status.waiting || status == Status.leave) {
          final DateTime now = DateTime.now();

          if (startTime.difference(now).inMinutes <= 25) {
            final String entry = now.toLocal().hour.toString().padLeft(2, "0");
            final String leave =
                now.toLocal().minute.toString().padLeft(2, "0");
            final String title = "$entry:$leave";

            showDialogHour(
              context,
              () => {
                if (status == Status.waiting)
                  {
                    if (kind == "std")
                      {
                        StatusHandler()
                            .entry(id!, startTime, endTime, now,
                                context.read<UserProvider>().accessToken)
                            .then((value) {
                          updateClasses();
                          Navigator.of(context).pop();
                        }).catchError((error) {})
                      }
                    else
                      {
                        StatusHandler()
                            .patch(
                                statusId as int,
                                now,
                                now.add(
                                  Duration(
                                      minutes: endTime
                                          .difference(startTime)
                                          .inMinutes),
                                ),
                                null,
                                context.read<UserProvider>().accessToken)
                            .then((value) {
                          updateClasses();
                          Navigator.of(context).pop();
                        }).catchError((error) {})
                      }
                  }
                else if (status == Status.leave)
                  {
                    StatusHandler()
                        .patch(statusId as int, (startRegister as DateTime),
                            now, null, context.read<UserProvider>().accessToken)
                        .then((value) {
                      updateClasses();
                      Navigator.of(context).pop();
                    }).catchError((error) {})
                  }
              },
              title,
              status == Status.waiting,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  "A presença só pode ser registrada a partir de 25 minutos antes do início da aula!",
                ),
                backgroundColor: Colors.amber,
                margin: EdgeInsets.only(
                  bottom: 55,
                ),
                duration: Duration(seconds: 5),
              ),
            );
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                    "${startTime.hour.toString().padLeft(2, "0")}:${startTime.minute.toString().padLeft(2, "0")} - ${endTime.hour.toString().padLeft(2, "0")}:${endTime.minute.toString().padLeft(2, "0")}",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(iconStatus,
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            Icon(
              icon.icon,
              color: iconColor,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
