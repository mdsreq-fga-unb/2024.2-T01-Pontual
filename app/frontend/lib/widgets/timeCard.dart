import 'package:flutter/material.dart';

class TimeCardWidget extends StatelessWidget {
  final String title;
  final String time;
  final bool isRegistered;
  final String status;
  final String endTime; // Hora de término da aula no formato "HH:MM"

  const TimeCardWidget({
    Key? key,
    required this.title,
    required this.time,
    required this.isRegistered,
    required this.status,
    required this.endTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime classEndTime = _getClassEndTime(endTime);
    Duration difference = now.difference(classEndTime);

    // Definir qual ícone deve aparecer com base na lógica
    Icon icon;
    Color iconColor;
    String iconStatus;

    if (isRegistered) {
      // Se a pessoa já bateu o ponto
      icon = Icon(Icons.check_circle, size: 32);
      iconColor = Colors.green;
      iconStatus = "Registro em ${status.split(" ").last}";
    } else if (difference.inMinutes <= 10) {
      // Se não bateu o ponto, mas a aula terminou há menos de 10 minutos
      icon = Icon(Icons.warning_amber_rounded, size: 32);
      iconColor = Colors.amber;
      iconStatus = "Aguardando Registro";
    } else {
      // Se não bateu o ponto e já passaram mais de 10 minutos
      icon = Icon(Icons.cancel, size: 32);
      iconColor = Colors.red;
      iconStatus = "Ponto não batido";
    }

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
              Text(iconStatus,
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          Icon(
            icon.icon,
            color: iconColor,
            size: 32,
          ),
        ],
      ),
    );
  }

  DateTime _getClassEndTime(String endTime) {
    // Extrair as horas e minutos da string "HH:MM"
    List<String> timeParts = endTime.split(":");
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Criar um DateTime para a hora de término da aula
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hours, minutes);
  }
}
