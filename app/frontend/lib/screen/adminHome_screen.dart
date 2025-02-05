import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/adminUsebar.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/dateCard.dart';
import 'package:frontend/widgets/employeeCards/lateCard.dart';
import 'package:frontend/widgets/employeeCards/onTimeCard.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Nome de Usuário",
        page: "Bem Vindo",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text('Datas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            SizedBox(height: 8),
            DateCardComponent(),
            SizedBox(height: 8),
            Text('Funcionários',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.red, size: 12),
                SizedBox(width: 5),
                Text('Atrasados',
                    style: TextStyle(fontSize: 12, color: Color(0xFF445668))),
              ],
            ),
            Latecard(
                turma: "TURMA 1",
                name: "Funcionário da SIlva de Okiveira",
                time: 20),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Icon(Icons.circle,
                    color: const Color.fromARGB(255, 18, 173, 52), size: 12),
                SizedBox(width: 5),
                Text('Registrados',
                    style: TextStyle(fontSize: 12, color: Color(0xFF445668))),
              ],
            ),
            OnTimeCard(
              turma: "TURMA 1",
              name: "Funcionário da SIlva de Okiveira",
              time: "08:37",
              delay: 5,
              lateRegister: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminUseBar(),
    );
  }
}
