import 'package:flutter/material.dart';
import 'package:frontend/api/users_handler.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/dialog_inputs.dart';
import 'package:provider/provider.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.email,
    required this.name,
    required this.uuid,
    required this.classes,
    required this.onPressed,
    required this.update,
    required this.active,
  });

  final String name, email, uuid;
  final int classes;
  final bool active;
  final Function(String) onPressed;
  final Function() update;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 42,
      width: 370,
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
                  "$name",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 11),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "$classes Turma(s) cadastradas",
                      style: TextStyle(fontSize: 8, color: Color(0xFF445668)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    active
                        ? IconButton(
                            onPressed: () => {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return DialogInputs(
                                    title: "Desativar Funcionário",
                                    onConfirm: () {
                                      UsersHandler()
                                          .activate(
                                              context
                                                  .read<UserProvider>()
                                                  .accessToken,
                                              email)
                                          .then((value) {
                                        update();
                                        Navigator.of(context).pop();
                                      }).catchError((error) {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        "Deseja realmente desativar o funcionário $name?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF445668),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            },
                            icon: Icon(Icons.remove_moderator_outlined),
                            color: Color(0xFFAB0D0D),
                            iconSize: 25,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          )
                        : SizedBox(),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => onPressed(uuid),
                          icon: active
                              ? Icon(Icons.arrow_circle_right_outlined)
                              : Icon(Icons.check_circle_outline_rounded),
                          color: active ? Color(0xFF2DA5D0) : Color(0xFF2DD046),
                          iconSize: 25,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        )
                      ],
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
