import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/notification_handler.dart';
import 'package:frontend/api/report_handler.dart';
import 'package:frontend/api/users_handler.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/utils/push_service.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/admin/settings_card.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/custom_input.dart';
import 'package:frontend/widgets/dialog_inputs.dart';
import 'package:frontend/widgets/usebar.dart';
import 'package:js/js_util.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static String getReportTitle(dynamic report, {bool withBreak = true}) {
    return "${report["start"].substring(8, 10)}/${report["start"].substring(5, 7)}/${report["start"].substring(0, 4)}${withBreak ? "\n" : ""} à ${withBreak ? "\n" : ""}${report["end"].substring(8, 10)}/${report["end"].substring(5, 7)}/${report["end"].substring(0, 4)}";
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

  const ProfileScreen({super.key});
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<dynamic> reports = [];

  void fetchReports() {
    ReportHandler().get(context.read<UserProvider>().accessToken).then((value) {
      setState(() {
        reports = value;
      });
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Perfil de Usuário",
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
            Container(
              padding: EdgeInsets.only(left: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.read<UserProvider>().name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    context.read<UserProvider>().email,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Configurações',
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
                promiseToFuture(checkSubscription()).then((value) {
                  if (value) {
                    subscribeUser(
                      "BLagAyHodIwY5MaQUqzdbFGHFjnyRKvKGnO7MOPVHHTQAS78372Ex1j_QYSVtEacqDEEeuOH6OH1b1F0RG15zRA",
                    ).then((value) {
                      NotificationHandler()
                          .delete(
                              context.read<UserProvider>().accessToken, value)
                          .then((value) {})
                          .catchError((error) {});
                    }).catchError((error) {});
                  }
                }).catchError((error) {});

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
              'Revisão de Relatório de Ponto',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              itemCount: reports.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    "${AppRoutes.Report}/${reports[index]["id"]}",
                  ),
                  child: Container(
                    width: 378,
                    height: 102,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          ProfileScreen.getReportTitle(reports[index]),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              String.fromCharCode(reports[index]["reviewed"]
                                  ? CupertinoIcons.check_mark_circled.codePoint
                                  : CupertinoIcons
                                      .exclamationmark_circle.codePoint),
                              style: TextStyle(
                                inherit: false,
                                color: reports[index]["reviewed"]
                                    ? Color(0xFF2FCB21)
                                    : Color(0xFFBB3901),
                                fontSize: 40,
                                fontWeight: FontWeight.normal,
                                fontFamily: reports[index]["reviewed"]
                                    ? CupertinoIcons
                                        .check_mark_circled.fontFamily
                                    : CupertinoIcons
                                        .exclamationmark_circle.fontFamily,
                                package: reports[index]["reviewed"]
                                    ? CupertinoIcons
                                        .check_mark_circled.fontPackage
                                    : CupertinoIcons
                                        .exclamationmark_circle.fontPackage,
                              ),
                            ),
                            Text(
                              reports[index]["reviewed"]
                                  ? "Revisado"
                                  : "Aguardando\nRevisão",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF445668),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: UseBar(
        updateClasses: () {},
        updateVIP: () {},
        isAddNotFloating: true,
        onHomePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.Home);
        },
        onProfilePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.Profile);
        },
      ),
    );
  }
}
