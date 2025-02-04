import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCardComponent extends StatelessWidget {
  final int focusCard;
  final void Function(int) setFocusCard;
  final void Function(DateTime) setDatetimeCard;

  final List<String> daysOfWeek = [
    "Sex",
    "Sab",
    "Dom",
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sab",
    "Dom"
  ];
  final DateTime today = DateTime.now();

  DateCardComponent(
      {required this.focusCard,
      required this.setFocusCard,
      required this.setDatetimeCard});

  List<DateTime> getWeekDays(DateTime date) {
    // Pega o primeiro dia da semana (segunda-feira)
    DateTime firstDayOfWeek = date.subtract(Duration(days: 2));
    return List.generate(
        5, (index) => firstDayOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = getWeekDays(today);
    int start = today.weekday;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(5, (index) {
        DateTime currentDate = weekDates[index];
        String day = daysOfWeek[(index + start) % 7];
        String date = DateFormat('d').format(currentDate);

        return _dateCard(day, date, index, currentDate);
      }),
    );
  }

  Widget _dateCard(String day, String date, int index, DateTime datetime) {
    bool isSelected = (focusCard == index);

    return GestureDetector(
      onTap: () {
        setFocusCard(index);
        setDatetimeCard(datetime);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: (isSelected) ? Colors.grey[400] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.grey.withAlpha((0.2 * 255).toInt()),
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
      ),
    );
  }
}
