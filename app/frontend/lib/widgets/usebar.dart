import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:frontend/screen/regist_home.dart';

class UseBar extends StatefulWidget {
  @override
  _UseBarState createState() => _UseBarState();
}

class _UseBarState extends State<UseBar> {
  int _currentIndex = 1; // Ícone "+" é o índice inicial

  final List<Widget> _pages = [
    // Lista de páginas para cada ícone
    Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(child: Text('Página Inicial')),
    ),
    RegistHome(), // Página criada para o botão "+"
    Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Center(child: Text('Página de Perfil')),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Exibe a página baseada no índice
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.home, color: Colors.white),
          Text(
            '+',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Icon(Icons.person_rounded, color: Colors.white),
        ],
        buttonBackgroundColor: Color(0xFFF08484),
        index: _currentIndex,
        backgroundColor: Color(0xFFEDEDED),
        color: Color(0xFFF08484),
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Atualiza o índice e, portanto, a página
          });
        },
      ),
    );
  }
}
