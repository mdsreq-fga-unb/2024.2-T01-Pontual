import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: CustomButton(
          text: 'Teste',
          onPressed: () {
            Navigator.pushNamed(context, '/about');
          },
        ),
      ),
    );
  }
}
