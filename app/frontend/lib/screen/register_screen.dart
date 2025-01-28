import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEDEDED),
      ),
      backgroundColor: Color(0xFFEDEDED),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 60 : 20,
                vertical: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: isWideScreen ? 60 : 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Seja Bem Vindo 👋 ',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: isWideScreen ? 32 : 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            'a ',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: isWideScreen ? 32 : 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'PONTUAL',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: isWideScreen ? 32 : 30,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFF08484)),
                          )
                        ],
                      )),
                  Divider(
                    color: Colors.pink, // Cor da linha
                    thickness: 1.0, // Espessura da linha
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    'Cadastre-se na nossa plataforma para utilizar os seus serviços',
                    style: TextStyle(
                        fontFamily: 'ArimoHebrewSubset',
                        fontSize: isWideScreen ? 20 : 15,
                        color: Colors.black),
                  ),
                  SizedBox(height: isWideScreen ? 70 : 40),
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
                    hintText: 'Nome',
                    controller: TextEditingController(),
                    keyboardType: TextInputType.name,
                  ),
                  CustomInput(
                    hintText: 'Email',
                    controller: TextEditingController(),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomInput(
                    hintText: 'Celular',
                    controller: TextEditingController(),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: isWideScreen ? 20 : 10),
                  CustomInput(
                    hintText: 'Senha',
                    controller: TextEditingController(),
                    isPassword: true,
                  ),
                  CustomInput(
                    hintText: 'Confirme a senha',
                    controller: TextEditingController(),
                    isPassword: true,
                  ),
                  CustomButton(
                    text: 'Cadastrar',
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.HP); //APENAS PARA TESTE
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
