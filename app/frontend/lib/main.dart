import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screen/adminHome_screen.dart';
import 'package:frontend/screen/adminReport_screen.dart';
import 'package:frontend/screen/adminSettings_screen.dart';
import 'package:frontend/screen/profile_screen.dart';
import 'package:frontend/utils/theme.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/home_page.dart';
// import 'screen/about_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // Remove a bandeira "Debug"
      theme: appTheme,
      initialRoute: '/',
      routes: {
        AppRoutes.LS: (context) => LoginScreen(),
        AppRoutes.RS: (context) => RegisterScreen(),
        AppRoutes.PS: (context) => ProfileScreen(),
        AppRoutes.HP: (context) => HomePage(),
        AppRoutes.AHP: (context) => AdminHome(),
        AppRoutes.ARP: (context) => AdminReportPage(),
        AppRoutes.ASP: (context) => AdminSettingsPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _navigationItem = [
    const Icon(Icons.home),
    const Icon(Icons.person),
    const Icon(Icons.plus_one),
  ];

  Color bgColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),
      body: Container(
        color: Color(0xFFEDEDED),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: _navigationItem,
        buttonBackgroundColor: Colors.pink,
        index: 1,
        backgroundColor: Color(0xFFEDEDED),
      ),
    );
  }
}
