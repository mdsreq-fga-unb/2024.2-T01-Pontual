// import 'package:frontend/screen/home_page.dart';
import 'package:frontend/screen/home_page.dart';
import 'package:frontend/widgets/checkbox_default.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/api/users_handler.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<UserProvider>().isAuthenticated;

    bool? rememberMe = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEDEDED),
      ),
      backgroundColor: Color(0xFFEDEDED),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Verifica se é uma tela maior (notebook) ou menor (mobile/tablet)
          bool isWideScreen = constraints.maxWidth > 600;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 60 : 20,
                vertical: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: isWideScreen ? 60 : 40),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(
                      'images/logo150x150.svg',
                      width: isWideScreen ? 200 : 150,
                      height: isWideScreen ? 200 : 150,
                    ),
                  ),
                  SizedBox(height: isWideScreen ? 20 : 5),
                  Text(
                    'PONTUAL',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: isWideScreen ? 42 : 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFF08484),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: isWideScreen ? 100 : 70),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'Preencha os campos abaixo',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: isWideScreen ? 18 : 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF757474),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isWideScreen ? 20 : 10),
                  CustomInput(
                    hintText: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: isWideScreen ? 20 : 10),
                  CustomInput(
                    hintText: 'Senha',
                    controller: passwordController,
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CheckboxDefault(
                                onChanged: (bool? value) =>
                                    {rememberMe = value}),
                            Text(
                              'Lembre-se de mim',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: isWideScreen ? 16 : 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF757474),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // LÓGICA PARA SENHA ESQUECIDA
                              },
                              child: Text(
                                'Esqueceu a senha?',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: isWideScreen ? 16 : 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFF08484),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.Register);
                              },
                              child: Text(
                                'Crie sua conta',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: isWideScreen ? 16 : 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFF08484),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: isWideScreen ? 30 : 10),
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      UsersHandler()
                          .login(emailController.text, passwordController.text, rememberMe)
                          .then((value) {
                        context.read<UserProvider>().login(
                            value['email'], value['name'], value['access']);
                        Navigator.of(context).pushNamed(AppRoutes.Home);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
