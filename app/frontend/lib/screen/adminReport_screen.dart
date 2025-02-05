import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/adminUsebar.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/dateCard.dart';
import 'package:frontend/widgets/employeeCards/lateCard.dart';

class AdminReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Nome de Usuário",
        page: "Bem Vindo",
      ),
      body: SingleChildScrollView(),
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
