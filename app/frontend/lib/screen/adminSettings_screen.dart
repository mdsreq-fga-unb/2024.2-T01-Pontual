import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/adminCards/settingsCard.dart';
import 'package:frontend/widgets/adminUsebar.dart';
import 'package:frontend/widgets/custom_appbar.dart';

class AdminSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Administrador",
        page: "Configurações",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Dados de Usuário',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Nome",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "email",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Configurações de Perfil',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 10,
            ),
            SettingsCard(
                title: "Alterar Senha",
                color: "#2DA5D0",
                icon: Icon(
                  Icons.edit,
                  color: Color(0xFF2DA5D0),
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              'Configurações de Admin',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 10,
            ),
            SettingsCard(
                title: "Adicionar Funcionário",
                color: "#2DA5D0",
                icon: Icon(
                  Icons.person_add_alt,
                  color: Color(0xFF2DA5D0),
                )),
            SettingsCard(
                title: "Gerenciar Turmas",
                color: "#2DA5D0",
                icon: Icon(
                  Icons.class_outlined,
                  color: Color(0xFF2DA5D0),
                )),
            SettingsCard(
                title: "Excluir Funcionário",
                color: "#AB0D0D",
                icon: Icon(
                  Icons.delete_outlined,
                  color: Color(0xFFFB0D0D),
                )),
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
