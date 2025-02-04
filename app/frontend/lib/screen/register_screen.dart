import 'package:flutter/material.dart';
import 'package:frontend/api/users_handler.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
                    controller: nameController,
                    keyboardType: TextInputType.name,
                  ),
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
                  CustomInput(
                    hintText: 'Confirme a senha',
                    controller: confirmPasswordController,
                    isPassword: true,
                  ),
                  CustomButton(
                    text: 'Cadastrar',
                    onPressed: () async {
                      List<List<dynamic>> controllers = [
                        [nameController, 'nome'],
                        [emailController, 'email'],
                        [passwordController, 'senha'],
                        [confirmPasswordController, 'confirmar senha']
                      ];

                      for (var i = 0; i < controllers.length; i++) {
                        if (controllers[i][0].text.trim() == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'O campo de ${controllers[i][1]} deve estar preenchido'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                      }

                      if (passwordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("As senhas devem ser iguais"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        await UsersHandler()
                            .register(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim())
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Registrado com sucesso. Espere um administrador aprovar sua conta e comece a usar o aplicativo!"),
                              backgroundColor: Colors.lightGreen,
                            ),
                          );
                          print(value);
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      }
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
