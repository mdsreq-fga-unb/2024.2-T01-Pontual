import 'package:flutter/material.dart';

void main() {
  runApp(RegistHome());
}

class RegistHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem Vindo',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              'Nome do Usuário',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text('Datas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dateCard('Seg', '2', false),
                _dateCard('Ter', '3', false),
                _dateCard('Qua', '4', true),
                _dateCard('Qui', '5', false),
                _dateCard('Sex', '6', false),
              ],
            ),
            SizedBox(height: 16),
            Text('Registro de Ponto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _timeCard('Turma 1', '08:00 - 09:10', true, 'Registro em 08:05'),
            _timeCard('Turma 2', '13:00 - 14:15', false, 'Aguardando Registro'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Turmas Especiais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: Text('Editar')),
              ],
            ),
            _timeCard('VIP 1', '07:00 - 08:00', true, 'Registro em 07:05'),
          ],
        ),
      ),
    );
  }

  Widget _dateCard(String day, String date, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[400] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        children: [
          Text(day, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(date, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _timeCard(String title, String time, bool isRegistered, String status) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(time, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(status, style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          Icon(
            isRegistered ? Icons.check_circle : Icons.warning_amber_rounded,
            color: isRegistered ? Colors.green : Colors.amber,
            size: 32,
          ),
        ],
      ),
    );
  }
}
