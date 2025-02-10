import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/users_handler.dart';
import 'package:frontend/screen/admin/admin_employees.dart';
import 'package:frontend/screen/admin/admin_employees_report.dart';
import 'package:frontend/screen/admin/admin_home.dart';
import 'package:frontend/screen/admin/admin_manage_classes.dart';
import 'package:frontend/screen/admin/admin_report.dart';
import 'package:frontend/screen/admin/admin_settings.dart';
import 'package:frontend/screen/report_screen.dart';
import 'package:frontend/utils/theme.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screen/profile_screen.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        final value = await UsersHandler().refresh();
        if (mounted) {
          context.read<UserProvider>().login(value['email'], value['name'],
              value['access'], value['uuid'], value['is_staff']);
        }
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        final authProvider = Provider.of<UserProvider>(context, listen: false);
        final uri = Uri.parse(settings.name!);

        final Map<String, Widget Function()> routes = {
          AppRoutes.Login: () => LoginScreen(),
          AppRoutes.Register: () => RegisterScreen(),
        };

        final Map<String, Widget Function()> protectedRoutes = {
          AppRoutes.Profile: () => ProfileScreen(),
          AppRoutes.Home: () => HomePage(),
          AppRoutes.Report: () => ReportScreen(
                reportId: int.parse(uri.pathSegments[1]),
              ),
          AppRoutes.AdminHome: () => AdminHome(),
          AppRoutes.AdminReport: () => AdminReportPage(),
          AppRoutes.AdminEmployeesReport: () => EmployeesReportPage(),
          AppRoutes.AdminSettings: () => AdminSettingsPage(),
          AppRoutes.AdminEmployeesSettings: () => AdminEmployees(),
          AppRoutes.AdminManageClasses: () => AdminEmployeeClasses(
                uuid: uri.pathSegments[1],
              ),
        };

        final cleanedRoute =
            uri.pathSegments.isEmpty ? '/' : '/${uri.pathSegments[0]}';

        if (protectedRoutes.containsKey(cleanedRoute) &&
            !authProvider.isAuthenticated) {
          return MaterialPageRoute(builder: (_) => LoginScreen());
        }

        final widgetBuilder = routes[cleanedRoute] ??
            protectedRoutes[cleanedRoute] ??
            () => LoginScreen();

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => widgetBuilder(),
        );
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
