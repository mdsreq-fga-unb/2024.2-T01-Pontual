import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/users_handler.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screen/profile_screen.dart';
import 'package:frontend/utils/theme.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/home_page.dart';
// import 'screen/about_screen.dart';

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
          context
              .read<UserProvider>()
              .login(value['email'], value['name'], value['access']);
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
      onGenerateRoute: (settings) {
        final authProvider = Provider.of<UserProvider>(context, listen: false);

        final Map<String, Widget Function()> routes = {
          AppRoutes.Login: () => LoginScreen(),
          AppRoutes.Register: () => RegisterScreen(),
        };

        final Map<String, Widget Function()> protectedRoutes = {
          AppRoutes.Profile: () => ProfileScreen(),
          AppRoutes.Home: () => HomePage()
        };

        if (protectedRoutes.containsKey(settings.name) &&
            !authProvider.isAuthenticated) {
          return MaterialPageRoute(builder: (_) => LoginScreen());
        }

        final widgetBuilder = routes[settings.name] ??
            protectedRoutes[settings.name] ??
            () => LoginScreen();

        return MaterialPageRoute(builder: (_) => widgetBuilder());
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
