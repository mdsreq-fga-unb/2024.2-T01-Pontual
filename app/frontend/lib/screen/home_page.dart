import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/dateCard.dart';
import 'package:frontend/widgets/usebar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text('Datas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DateCardComponent(),
            SizedBox(height: 16),
            Text('Registro de Ponto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _timeCard('Turma 1', '08:00 - 09:10', true, 'Registro em 08:05'),
            _timeCard('Turma 2', '13:00 - 14:15', false, 'Aguardando Registro'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Turmas Especiais',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: Text('Editar')),
              ],
            ),
            _timeCard('VIP 1', '07:00 - 08:00', true, 'Registro em 07:05'),
          ],
        ),
      ),
      bottomNavigationBar: UseBar(
        onAddPressed: () {
          print('Adicionar pressionado');
        },
        onHomePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.HP);
        },
        onProfilePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.UH);
        },
      ),
    );
  }

  Widget _timeCard(
      String title, String time, bool isRegistered, String status) {
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
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(time,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
