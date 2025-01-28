import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    controller: TextEditingController(),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: isWideScreen ? 20 : 10),
                  CustomInput(
                    hintText: 'Senha',
                    controller: TextEditingController(),
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (bool? value) {
                                // LOGICA CHECKBOX
                              },
                            ),
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
                      ],
                    ),
                  ),
                  SizedBox(height: isWideScreen ? 30 : 10),
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.RS); //APENAS PARA TESTE
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
