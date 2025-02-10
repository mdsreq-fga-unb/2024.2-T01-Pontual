import 'package:flutter/material.dart';
import 'package:frontend/api/report_handler.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screen/profile_screen.dart';
import 'package:frontend/utils/pdf_generator.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/admin/admin_userbar.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/report_table.dart';
import 'package:frontend/widgets/usebar.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  final int reportId;

  const ReportScreen({super.key, required this.reportId});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<bool> toggles = [];
  bool isEditable = false;
  dynamic report;

  dynamic fetchReport() {
    ReportHandler()
        .get(context.read<UserProvider>().accessToken, id: widget.reportId)
        .then((value) {
      setState(() {
        report = value;
        int num = 0;
        for (var row in report['report']) {
          num += (row["statuses"] as List).length;
        }
        toggles = List.generate(num, (index) => false);
      });
    }).catchError((error) {});
  }

  Widget getButtons() {
    if (isEditable) return SizedBox();
    return Column(
      children: [
        SizedBox(height: 10),
        CustomButton(
          width: 215,
          height: 35,
          text: report != null && report['reviewed']
              ? "Relatório Revisado"
              : report != null && report['to_review']
                  ? "Revisão Solicitada"
                  : "Solicitar Revisão",
          color: Color(0xFF2DD046),
          disabled: report != null && report["to_review"],
          icon: Icons.brush_outlined,
          textStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          onPressed: () {
            ReportHandler()
                .reviewUnique(
                    context.read<UserProvider>().accessToken, report["id"])
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Relatório enviado para revisão!"),
                  backgroundColor: Colors.lightGreen,
                ),
              );
              setState(() {
                report["to_review"] = true;
              });
            }).catchError((error) {});
          },
        ),
        SizedBox(height: 10),
        CustomButton(
          width: 215,
          height: 35,
          text: "Emitir PDF",
          color: Color(0xFFD02D48),
          icon: Icons.ios_share_outlined,
          textStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Emitindo PDFs"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        "Aguarde enquanto os PDFs são gerados...",
                      ),
                    ],
                  ),
                );
              },
            );

            final pdf = await generateReportPDF(
              context,
              report['id'],
              report['user'],
            );

            downloadPDFs(
              [pdf],
              [
                "${report['user']['name'].toString().toLowerCase().split(" ").join('-')}-${report['user']['email'].split('@')[0]}"
              ],
              zip: false,
            );

            await Future.delayed(Duration(seconds: 1, microseconds: 500));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget getEditButton() {
    if (isEditable) {
      return Column(
        children: [
          CustomButton(
            width: 215,
            height: 35,
            text: "Salvar",
            color: Color(0xFF2DA5D0),
            icon: Icons.edit_outlined,
            textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            onPressed: () {
              if (toggles.contains(true)) {
                ReportHandler()
                    .toggle(context.read<UserProvider>().accessToken,
                        report['id'], toggles)
                    .then((value) {
                  fetchReport();
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erro ao salvar alterações!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              }
              setState(() {
                isEditable = !isEditable;
              });
            },
          ),
          SizedBox(height: 10),
          CustomButton(
            width: 215,
            height: 35,
            text: "Cancelar",
            color: Color(0xFFD02D48),
            icon: Icons.close,
            textStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isEditable = !isEditable;
              });
            },
          ),
        ],
      );
    }
    return CustomButton(
      width: 215,
      height: 35,
      text: "Editar",
      color: Color(0xFF2DA5D0),
      icon: Icons.edit_outlined,
      textStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
          isEditable = !isEditable;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: report == null
            ? ""
            : ProfileScreen.getReportTitle(
                report,
                withBreak: false,
              ),
        page: "Registro de Ponto",
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (context.read<UserProvider>().isAdmin) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushNamed(AppRoutes.Profile);
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF2DA5D0),
                    size: 15,
                  ),
                  Text(
                    context.read<UserProvider>().isAdmin
                        ? "Relatórios por Funcionário"
                        : "Perfil",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2DA5D0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: report == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ReportTable(
                        report: report,
                        isEditable: isEditable,
                        toggles: toggles,
                      ),
              ),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Horas Totais: ${report == null ? "" : (report["total_minutes"] ~/ 60).toString().padLeft(2, "0")}:${report == null ? "" : (report["total_minutes"] % 60).toString().padLeft(2, "0")}",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "Faltas: ${report == null ? "" : report["absences"]}",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                context.read<UserProvider>().isAdmin
                    ? Column(
                        children: [
                          getEditButton(),
                          getButtons(),
                        ],
                      )
                    : CustomButton(
                        width: 205,
                        height: 45,
                        text: report != null && report['reviewed']
                            ? "Relatório Aceito"
                            : "Aceitar Relatório",
                        textStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                        ),
                        color: report != null && report['reviewed']
                            ? Color(0xFF2DD046)
                            : Color(0xFF2DA5D0),
                        icon: report != null && report['reviewed']
                            ? Icons.check
                            : Icons.edit_outlined,
                        onPressed: () {
                          if (!report['reviewed']) {
                            ReportHandler()
                                .review(
                                    context.read<UserProvider>().accessToken,
                                    report['id'])
                                .then((value) {
                              fetchReport();
                            }).catchError((error) {});
                          }
                        },
                      ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: !context.read<UserProvider>().isAdmin
          ? UseBar(
              updateClasses: () {},
              updateVIP: () {},
              isAddNotFloating: true,
              onHomePressed: () {
                Navigator.of(context).pushNamed(AppRoutes.Home);
              },
              onProfilePressed: () {
                Navigator.of(context).pushNamed(AppRoutes.Profile);
              },
            )
          : AdminUseBar(
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
