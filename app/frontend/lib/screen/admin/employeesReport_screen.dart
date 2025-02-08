import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/adminCards/employeeReportCard.dart';
import 'package:frontend/widgets/adminUsebar.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeesReportPage extends StatefulWidget {
  @override
  _EmployeesReportPageState createState() => _EmployeesReportPageState();
}

class _EmployeesReportPageState extends State<EmployeesReportPage> {
  String dateBegin = 'Carregando...';
  String dateEnd = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadSavedDates();
  }

  Future<void> _loadSavedDates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dateBegin = prefs.getString('dateBegin') ?? 'Data não disponível';
      dateEnd = prefs.getString('dateEnd') ?? 'Data não disponível';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Relatório de Funcionários",
        page: "$dateBegin - $dateEnd",
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
                    Navigator.of(context).pushNamed(AppRoutes.ARP);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios,
                          color: Color(0xFF2DA5D0), size: 15),
                      Text("Relatórios Mensais",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFF2DA5D0))),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text("Funcionários do período $dateBegin - $dateEnd",
                    style: TextStyle(fontSize: 12, color: Color(0xFF445668))),
                SizedBox(height: 10),
                EmployeeReportCard(
                    date: "$dateBegin - $dateEnd",
                    name: "Funcionário da Silva",
                    hours: 300,
                    lateTime: "00:05",
                    missing: 2,
                    reviewed: true),
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
                    onPressed: () => {},
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
                    label: Text("Solicitar Assinatura",
                        style: TextStyle(fontSize: 13)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => {},
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
                    label: Text("Emitir PDF", style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
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
