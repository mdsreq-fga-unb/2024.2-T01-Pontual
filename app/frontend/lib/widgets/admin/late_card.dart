import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/notification_handler.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Latecard extends StatefulWidget {
  const Latecard({
    super.key,
    required this.date,
    required this.turma,
    required this.name,
    required this.uuid,
    required this.time,
  });

  final String turma, name, uuid;
  final int time;
  final String date;

  @override
  State<Latecard> createState() => _LatecardState();
}

class _LatecardState extends State<Latecard> {
  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.date));

    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.turma,
                  style: TextStyle(color: Color(0xFF445668), fontSize: 10),
                ),
                Text(
                  widget.name,
                  style: TextStyle(color: Colors.black, fontSize: 11),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text(
                  "${widget.time ~/ 60}h e ${widget.time % 60}min",
                  style: TextStyle(
                    color: Color(0xFF445668),
                    fontSize: 16,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NotificationHandler().notify(
                          context.read<UserProvider>().accessToken,
                          {
                            "uuid": widget.uuid,
                            "message":
                                "Verificar registro: ${widget.turma} - $formattedDate.",
                          },
                        ).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Notificação enviada!"),
                              backgroundColor: Colors.lightGreen,
                            ),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "O usuário está com as notificações desativadas ou não está logado. Tente contato direto.",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      },
                      child: Text(
                        String.fromCharCode(
                            CupertinoIcons.bubble_left.codePoint),
                        style: TextStyle(
                          inherit: false,
                          color: Color(0xFF2DA5D0),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: CupertinoIcons.bubble_left.fontFamily,
                          package: CupertinoIcons.bubble_left.fontPackage,
                        ),
                      ),
                    ),
                    Text(
                      "Notificação",
                      style: TextStyle(
                        color: Color(0xFF2DA5D0),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
