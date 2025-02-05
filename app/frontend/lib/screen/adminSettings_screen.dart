import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/adminUsebar.dart';
import 'package:frontend/widgets/custom_appbar.dart';

class AdminSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: "Configurações",
        page: "Administrador",
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
