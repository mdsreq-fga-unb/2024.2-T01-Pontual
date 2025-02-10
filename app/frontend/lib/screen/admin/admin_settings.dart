import 'package:flutter/material.dart';
import 'package:frontend/api/users_handler.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/admin/admin_userbar.dart';
import 'package:frontend/widgets/admin/settings_card.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/custom_input.dart';
import 'package:frontend/widgets/dialog_inputs.dart';
import 'package:provider/provider.dart';

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
                    context.read<UserProvider>().name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    context.read<UserProvider>().email,
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
              title: "Sair",
              color: "#AB0D0D",
              icon: Icon(
                Icons.exit_to_app,
                color: Color(0xFFAB0D0D),
              ),
              onPressed: () {
                UsersHandler()
                    .logout(context.read<UserProvider>().accessToken)
                    .then((value) {
                  context.read<UserProvider>().logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.Login,
                    (route) => false,
                  );
                }).catchError((error) {});
              },
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
              ),
              onPressed: () {
                final passwordController = TextEditingController();

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        child: DialogInputs(
                          title: "Mudar Senha",
                          child: CustomInput(
                            width: 200,
                            height: 50,
                            hintText: 'Senha',
                            controller: passwordController,
                            isPassword: true,
                          ),
                          onConfirm: () {
                            UsersHandler()
                                .password(
                                    context.read<UserProvider>().accessToken,
                                    passwordController.text)
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Senha alterada com sucesso!"),
                                  backgroundColor: Colors.lightGreen,
                                ),
                              );
                              Navigator.of(context).pop();
                            }).catchError((error) {});
                          },
                        ),
                      );
                    });
              },
            ),
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
              title: "Gerenciar Funcionários",
              color: "#2DA5D0",
              icon: Icon(
                Icons.person_outline,
                color: Color(0xFF2DA5D0),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.AdminEmployeesSettings);
              },
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
