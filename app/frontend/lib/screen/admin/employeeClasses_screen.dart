import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/utils/dialog_functions.dart';
import 'package:frontend/widgets/adminCards/ClassCard.dart';
import 'package:frontend/widgets/adminUsebar.dart';
import 'package:frontend/widgets/custom_appbar.dart';

class AdminEmployeeClasses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Gerenciar Turma",
        page: "Configurações",
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.AEP);
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
                        "Nome",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "email",
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
                Column(
                  children: List.generate(
                    5, // Simulação de várias turmas
                    (index) => ClassCard(
                      name: "Turma ${index + 1}",
                      days: "Seg, Qua, Sex",
                      beginTime: "08:00",
                      endTime: "09:00",
                      classType: "Infantil",
                      durationBegin: "10/11/2024",
                      durationEnd: "10/11/2025",
                    ),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => showDialogNewClass(context),
              backgroundColor: Color(0xFF2DA5D0),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
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
