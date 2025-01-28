import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_appbar.dart';
// import 'package:frontend/widgets/usebar.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_input.dart';

class UserHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Color(0xFFEDEDED),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 300;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 60 : 20,
                vertical: 10,
              ),
            ),
          );
        },
      ),
      // bottomNavigationBar: UseBar(),
    );
  }
}
