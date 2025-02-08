import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/dateCard.dart';
import 'package:frontend/widgets/timeCard.dart';
import 'package:frontend/widgets/usebar.dart';
import 'package:frontend/utils/dialog_functions.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Nome de Usuário",
        page: "Bem-Vindo",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Datas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 8),
            DateCardComponent(),
            SizedBox(height: 16),
            Text(
              'Registro de Ponto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TimeCardWidget(
              title: 'Turma 2',
              time: '19:45 - 21:00',
              isRegistered: false,
              status: 'Aguardando Registro',
              endTime: '21:00',
            ),
            TimeCardWidget(
              title: 'Turma 2',
              time: '21:00 - 22:15',
              isRegistered: false,
              status: 'Aguardando Registro',
              endTime: '22:15',
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Turmas Especiais',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    showDialogEditClass(context);
                  },
                  child: Text('Editar'),
                ),
              ],
            ),
            TimeCardWidget(
              title: 'Turma 2',
              time: '13:00 - 14:15',
              isRegistered: false,
              status: 'Aguardando Registro',
              endTime: '14:15',
            ),
          ],
        ),
      ),
      bottomNavigationBar: UseBar(
        onHomePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.HP);
        },
        onProfilePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.PS);
        },
      ),
    );
  }
}
