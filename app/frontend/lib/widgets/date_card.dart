import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCardComponent extends StatelessWidget {
  final int? focusCard;
  final int indexSubtract;
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
      required this.setDatetimeCard,
      this.indexSubtract = 2});

  List<DateTime> getWeekDays(DateTime date) {
    DateTime firstDayOfWeek = date.subtract(Duration(days: indexSubtract));
    return List.generate(
        5, (index) => firstDayOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = getWeekDays(today);
    int start = today.weekday - (indexSubtract - 2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(5, (index) {
        DateTime currentDate = weekDates[index];
        String day = daysOfWeek[(index + start) % 7];
        String date = DateFormat('d').format(currentDate);

        return _dateCard(context, day, date, index, currentDate);
      }),
    );
  }

  Widget _dateCard(BuildContext context, String day, String date, int index,
      DateTime datetime) {
    bool isSelected = (focusCard == index);

    return GestureDetector(
      onTap: () {
        setFocusCard(index);
        setDatetimeCard(datetime);
      },
      child: Container(
        width: MediaQuery.of(context).size.width > 380 ? 66 : 56,
        height: 62,
        decoration: BoxDecoration(
          color: (isSelected) ? Color(0xFFBEBABA) : Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(15),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF445668),
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
