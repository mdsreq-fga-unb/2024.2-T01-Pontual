import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/dialog_options.dart';
import 'package:frontend/widgets/usebar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(),
      body: DialogOptions(),
      bottomNavigationBar: UseBar(
        onHomePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.HP);
        },
        onProfilePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.PS);
        },
      ),
    );
  }
}
