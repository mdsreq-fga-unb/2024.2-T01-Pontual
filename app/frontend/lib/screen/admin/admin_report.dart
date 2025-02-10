import 'package:flutter/material.dart';
import 'package:frontend/api/report_handler.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screen/profile_screen.dart';
import 'package:frontend/utils/dialog_functions.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/admin/date_report_card.dart';
import 'package:frontend/widgets/admin/admin_userbar.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/report_button.dart';
import 'package:provider/provider.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({super.key});

  @override
  _AdminReportPageState createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
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
    Map<int, List<dynamic>> groupedReports = {};

    for (var report in reports) {
      int year = DateTime.parse(report['start']!).year;
      if (!groupedReports.containsKey(year)) {
        groupedReports[year] = [];
      }
      groupedReports[year]!.add(report);
    }

    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: context.read<UserProvider>().name,
        page: "Bem Vindo",
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Relatórios",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var year in groupedReports.keys.toList()
                      ..sort((a, b) => b.compareTo(a))) ...[
                      Text("$year", style: TextStyle(fontSize: 10)),
                      SizedBox(height: 5),
                      ...groupedReports[year]!.map((report) => DateReportCard(
                            title: ProfileScreen.getReportTitle(report,
                                withBreak: false),
                            start: report['start'].substring(0, 19),
                            end: report['end'].substring(0, 19),
                          )),
                      SizedBox(height: 15),
                    ]
                  ],
                ),
              ),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ReportButton(
                  onPressed: () =>
                      showDialogReport(context, (String start, String end) {
                    ReportHandler()
                        .post(
                      context.read<UserProvider>().accessToken,
                      start,
                      end,
                    )
                        .then((value) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Relatórios gerados com sucesso!"),
                          backgroundColor: Colors.lightGreen,
                        ),
                      );
                      fetchReports();
                    }).catchError((error) {});
                  }),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: AdminUseBar(
        onHomePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.AdminHome);
        },
        onReportPressed: () {},
        onSettingsPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.AdminSettings);
        },
      ),
    );
  }
}
