import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/adminCards/employeeCard.dart';
import 'package:frontend/widgets/adminUsebar.dart';
import 'package:frontend/widgets/custom_appbar.dart';

class AdminEmployees extends StatelessWidget {
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
                    Navigator.of(context).pushNamed(AppRoutes.ASP);
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
                Text("Funcionários",
                    style: TextStyle(fontSize: 12, color: Color(0xFF445668))),
                SizedBox(height: 10),
                EmployeeCard(
                    name: "Funcionário da Silva Olivreira", classes: 10)
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminUseBar(
        onHomePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.AHP);
        },
        onReportPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.ARP);
        },
        onSettingsPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.ASP);
        },
      ),
    );
  }
}
