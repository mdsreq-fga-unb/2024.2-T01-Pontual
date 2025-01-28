import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCardComponent extends StatefulWidget {
  @override
  _DateCardComponentState createState() => _DateCardComponentState();
}

class _DateCardComponentState extends State<DateCardComponent> {
  final List<String> daysOfWeek = ["Seg", "Ter", "Qua", "Qui", "Sex"];
  DateTime today = DateTime.now();

  List<DateTime> getWeekDays(DateTime date) {
    // Pega o primeiro dia da semana (segunda-feira)
    DateTime firstDayOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(
        5, (index) => firstDayOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = getWeekDays(today);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(daysOfWeek.length, (index) {
        DateTime currentDate = weekDates[index];
        String day = daysOfWeek[index];
        String date = DateFormat('d').format(currentDate);

        // Verifica se o card é o referente ao dia atual
        bool isToday = currentDate.day == today.day &&
            currentDate.month == today.month &&
            currentDate.year == today.year;

        return _dateCard(
          day,
          date,
          isToday, // Card mais escuro para o dia atual
        );
      }),
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
          Text(
            day,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
