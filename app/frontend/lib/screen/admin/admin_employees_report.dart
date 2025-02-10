import 'package:flutter/material.dart';
import 'package:frontend/api/report_handler.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/utils/pdf_generator.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/admin/employee_report_card.dart';
import 'package:frontend/widgets/admin/admin_userbar.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class EmployeesReportPage extends StatefulWidget {
  @override
  _EmployeesReportPageState createState() => _EmployeesReportPageState();

  const EmployeesReportPage({super.key});
}

class _EmployeesReportPageState extends State<EmployeesReportPage> {
  List<dynamic> reports = [];

  Map<String, String> getArgs() {
    return ModalRoute.of(context)!.settings.arguments as Map<String, String>;
  }

  void fetchReportsPerEmployee(String start, String end) {
    ReportHandler()
        .get(
      context.read<UserProvider>().accessToken,
      start: start,
      end: end,
    )
        .then((value) {
      setState(() {
        reports = value;
        reports.sort((a, b) => a['user']['name'].compareTo(b['user']['name']));
      });
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = getArgs();
      fetchReportsPerEmployee(args['start']!, args['end']!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = getArgs();

    final startDt = DateTime.parse(args['start']!);
    final endDt = DateTime.parse(args['end']!);

    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Relatórios por Funcionário",
        page:
            "${startDt.day.toString().padLeft(2, "0")}/${startDt.month.toString().padLeft(2, "0")}/${startDt.year} - ${endDt.day.toString().padLeft(2, "0")}/${endDt.month.toString().padLeft(2, "0")}/${endDt.year}",
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.AdminReport);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios,
                          color: Color(0xFF2DA5D0), size: 15),
                      Text("Relatórios",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFF2DA5D0))),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text("Funcionários",
                    style: TextStyle(fontSize: 12, color: Color(0xFF445668))),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: reports.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) => EmployeeReportCard(
                        id: reports[index]['id'],
                        email: reports[index]['user']['email'],
                        name: reports[index]['user']['name'],
                        hours: reports[index]['total_minutes'] ~/ 60,
                        minutes: reports[index]['total_minutes'] % 60,
                        missing: reports[index]['absences'],
                        reviewed: reports[index]['reviewed'],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80), // Espaço para não cobrir conteúdo
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Color(0XFFEDEDED),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ReportHandler()
                          .requestReview(
                              context.read<UserProvider>().accessToken,
                              startDt,
                              endDt)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Relatórios enviados para revisão!"),
                            backgroundColor: Colors.lightGreen,
                          ),
                        );
                      }).catchError((error) {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF2DD046),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(
                      Icons.brush_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: Text("Solicitar Revisões",
                        style: TextStyle(fontSize: 13)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      List<List<int>> pdfs = [];
                      List<String> emails = [];

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

                      for (var i = 0; i < reports.length; i++) {
                        final report = reports[i];
                        final pdf = await generateReportPDF(
                          context,
                          report['id'],
                          report['user'],
                        );
                        pdfs.add(pdf);
                        emails.add(
                          "${report['user']['name'].toString().toLowerCase().split(" ").join('-')}-${report['user']['email'].split('@')[0]}",
                        );
                      }

                      downloadPDFs(pdfs, emails);

                      await Future.delayed(Duration(seconds: 1, microseconds: 500));
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD02D48),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(
                      Icons.ios_share_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: Text("Emitir PDFs", style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
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
