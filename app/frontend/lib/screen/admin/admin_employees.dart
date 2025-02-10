import 'package:flutter/material.dart';
import 'package:frontend/api/users_handler.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/admin/admin_userbar.dart';
import 'package:frontend/widgets/admin/employee_card.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class AdminEmployees extends StatefulWidget {
  @override
  _AdminEmployeesState createState() => _AdminEmployeesState();

  const AdminEmployees({super.key});
}

class _AdminEmployeesState extends State<AdminEmployees> {
  List<dynamic> users = [];

  void fetchUsers() {
    UsersHandler().get(context.read<UserProvider>().accessToken).then((value) {
      setState(() {
        users = value;
      });
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Gerenciar Turmas",
        page: "Configurações",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.AdminSettings);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF2DA5D0),
                        size: 15,
                      ),
                      Text(
                        "Configurações",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF2DA5D0)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Funcionários Ativos",
                    style: TextStyle(fontSize: 12, color: Color(0xFF445668))),
                SizedBox(height: 10),
                ListView.builder(
                  itemCount: users.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (users[index]['is_active']) {
                      return EmployeeCard(
                        onPressed: (String uuid) {
                          Navigator.of(context).pushNamed(
                              "${AppRoutes.AdminManageClasses}/$uuid");
                        },
                        active: true,
                        uuid: users[index]['uuid'],
                        name: users[index]['name'],
                        email: users[index]['email'],
                        update: fetchUsers,
                        classes: users[index]['classes'],
                      );
                    }
                    return SizedBox();
                  },
                ),
                Text(
                  "Funcionários Inativos",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF445668),
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  itemCount: users.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (!users[index]['is_active']) {
                      return EmployeeCard(
                        onPressed: (String email) {
                          UsersHandler()
                              .activate(
                                  context.read<UserProvider>().accessToken,
                                  users[index]['email'])
                              .then((value) {
                            fetchUsers();
                          }).catchError((error) {});
                        },
                        active: false,
                        uuid: users[index]['uuid'],
                        name: users[index]['name'],
                        email: users[index]['email'],
                        update: fetchUsers,
                        classes: users[index]['classes'],
                      );
                    }
                    return SizedBox();
                  },
                )
              ],
            ),
          ],
        ),
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
