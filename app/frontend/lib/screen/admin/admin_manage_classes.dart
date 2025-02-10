import 'package:flutter/material.dart';
import 'package:frontend/api/classes_handler.dart';
import 'package:frontend/api/users_handler.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/utils/dialog_functions.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/admin/admin_userbar.dart';
import 'package:frontend/widgets/admin/class_card.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class AdminEmployeeClasses extends StatefulWidget {
  final String uuid;

  const AdminEmployeeClasses({super.key, required this.uuid});

  @override
  _AdminEmployeeClassesState createState() => _AdminEmployeeClassesState();
}

class _AdminEmployeeClassesState extends State<AdminEmployeeClasses> {
  dynamic user;

  void fetchUserInfo() {
    UsersHandler()
        .info(context.read<UserProvider>().accessToken, widget.uuid)
        .then((value) {
      setState(() {
        user = value;
      });
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> daysOfWeek = [
      "Domingo",
      "Segunda",
      "Terça",
      "Quarta",
      "Quinta",
      "Sexta",
      "Sábado",
    ];

    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Gerenciar Turma",
        page: "Configurações",
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.AdminEmployeesSettings);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF2DA5D0),
                        size: 15,
                      ),
                      Text(
                        "Funcionários",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF2DA5D0)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user != null ? user['name'] : "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        user != null ? user['email'] : "",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Turmas Cadastradas',
                  style: TextStyle(fontSize: 12, color: Color(0XFF445668)),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: user != null ? user['classes'].length : 0,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final start = DateTime.parse(
                            user['classes'][index]['start_range']);
                        final end =
                            DateTime.parse(user['classes'][index]['end_range']);

                        final durationBegin =
                            "${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}";
                        final durationEnd =
                            "${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}";

                        return ClassCard(
                          name: user['classes'][index]['name'],
                          days: user['classes'][index]['days']
                              .map((day) => daysOfWeek[day].substring(0, 3))
                              .join(", "),
                          beginTime: user['classes'][index]['start_time']
                              .substring(0, 5),
                          endTime: user['classes'][index]['end_time']
                              .substring(0, 5),
                          canDelete: user['status_count'] == 0 &&
                              !user['report_check'],
                          onDelete: () {
                            ClassesHandler()
                                .delete(
                                    context.read<UserProvider>().accessToken,
                                    user['classes'][index]['id'])
                                .then((value) {
                              fetchUserInfo();
                            }).catchError((error) {});
                          },
                          durationBegin: durationBegin,
                          durationEnd: durationEnd,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 70),
                Text(
                  'Somente turmas ainda sem\nregistro podem ser excluídas!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0XFF445668),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => showDialogNewClass(
                context,
                user['uuid'],
                fetchUserInfo,
              ),
              backgroundColor: Color(0xFF2DA5D0),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminUseBar(
        onHomePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.AdminHome);
        },
        onReportPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.AdminReport);
        },
        onSettingsPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.AdminSettings);
        },
      ),
    );
  }
}
