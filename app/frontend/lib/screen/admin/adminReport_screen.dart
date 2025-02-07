import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/utils/dialog_functions.dart';
import 'package:frontend/widgets/adminCards/dateReportCard.dart';
import 'package:frontend/widgets/adminUsebar.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/reportButton.dart';

class AdminReportPage extends StatelessWidget {
  final List<Map<String, String>> reports = [
    {"dateBegin": "06/04/2025", "dateEnd": "05/05/2025"},
    {"dateBegin": "07/05/2025", "dateEnd": "06/06/2025"},
    {"dateBegin": "08/06/2025", "dateEnd": "07/07/2025"},
    {"dateBegin": "06/04/2024", "dateEnd": "05/05/2024"},
    {"dateBegin": "07/05/2024", "dateEnd": "06/06/2024"},
    {"dateBegin": "08/06/2024", "dateEnd": "07/07/2024"},
  ];

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, String>>> groupedReports = {};

    for (var report in reports) {
      String year = report['dateBegin']!.split("/").last;
      if (!groupedReports.containsKey(year)) {
        groupedReports[year] = [];
      }
      groupedReports[year]!.add(report);
    }

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Relatórios Mensais",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
              ],
            ),
            for (var year in groupedReports.keys.toList()
              ..sort((a, b) => b.compareTo(a))) ...[
              Text(year, style: TextStyle(fontSize: 10)),
              SizedBox(height: 5),
              ...groupedReports[year]!.map((report) => DateReportCard(
                    dateBegin: report['dateBegin']!,
                    dateEnd: report['dateEnd']!,
                  )),
              SizedBox(height: 15),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ReportButton(
                  onPressed: () => showDialogReport(context),
                )
              ],
            )
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
