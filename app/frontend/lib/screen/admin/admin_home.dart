import 'package:flutter/material.dart';
import 'package:frontend/api/classes_handler.dart';
import 'package:frontend/api/status_handler.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/admin/late_card.dart';
import 'package:frontend/widgets/admin/on_time_card.dart';
import 'package:frontend/widgets/admin/admin_userbar.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/date_card.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  DateTime datetimeCard = DateTime.now();
  int focusCard = 4;

  List<dynamic> delayed = [];
  List<dynamic> onTime = [];

  List<int> getYearMonthDay() {
    final endYear = datetimeCard.year;
    final endMonth = datetimeCard.month;
    final endDay = datetimeCard.day;
    final startYear = datetimeCard.subtract(Duration(days: 4)).year;
    final startMonth = datetimeCard.subtract(Duration(days: 4)).month;
    final startDay = datetimeCard.subtract(Duration(days: 4)).day;

    return [startYear, startMonth, startDay, endYear, endMonth, endDay];
  }

  void fetchDelayed() {
    final [
      startYear,
      startMonth,
      startDay,
      endYear,
      endMonth,
      endDay,
    ] = getYearMonthDay();

    ClassesHandler()
        .getAllDelayed(
            "$startYear-$startMonth-$startDay",
            "$endYear-$endMonth-$endDay",
            context.read<UserProvider>().accessToken)
        .then((value) {
      setState(() {
        delayed = value;
      });
    }).catchError((error) {});
  }

  void fetchOnTime() {
    final [
      startYear,
      startMonth,
      startDay,
      endYear,
      endMonth,
      endDay,
    ] = getYearMonthDay();

    StatusHandler()
        .getByRange(
            "$startYear-$startMonth-${startDay}T00:00:00",
            "$endYear-$endMonth-${endDay}T23:59:59",
            context.read<UserProvider>().accessToken,
            at: 1)
        .then((value) {
      setState(() {
        onTime = value;
      });
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();
    fetchDelayed();
    fetchOnTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEDEDED),
      appBar: CustomAppBar(
        title: context.watch<UserProvider>().name,
        page: "Bem Vindo",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text('Datas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            SizedBox(height: 8),
            DateCardComponent(
              focusCard: focusCard,
              setFocusCard: (int index) {
                setState(() {
                  focusCard = index;
                });
              },
              setDatetimeCard: (DateTime datetime) {
                setState(() {
                  datetimeCard = datetime;
                });
              },
              indexSubtract: 4,
            ),
            SizedBox(height: 8),
            Text('Funcionários',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.red, size: 12),
                SizedBox(width: 5),
                Text('Atrasados',
                    style: TextStyle(fontSize: 12, color: Color(0xFF445668))),
              ],
            ),
            Center(
              child: SizedBox(
                width: 370,
                child: ListView.builder(
                  itemCount: delayed.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (DateTime.parse(delayed[index]["date"]).weekday ==
                        datetimeCard.weekday) {
                      return Latecard(
                        date: delayed[index]["date"],
                        uuid: delayed[index]["user_uuid"],
                        turma: delayed[index]["name"],
                        name: delayed[index]["user_name"],
                        time: delayed[index]["delay_in_minutes"],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Icon(Icons.circle,
                    color: const Color.fromARGB(255, 18, 173, 52), size: 12),
                SizedBox(width: 5),
                Text('Registrados',
                    style: TextStyle(fontSize: 12, color: Color(0xFF445668))),
              ],
            ),
            Center(
              child: SizedBox(
                width: 370,
                child: ListView.builder(
                  itemCount: onTime.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final DateTime register =
                        DateTime.parse(onTime[index]["register"][0]);
                    final DateTime expected =
                        DateTime.parse(onTime[index]["expected"][0]);

                    if (expected.weekday == datetimeCard.weekday) {
                      return OnTimeCard(
                        turma: onTime[index]["name"],
                        name: onTime[index]["user_name"],
                        time:
                            "${register.subtract(Duration(hours: 3)).hour.toString().padLeft(2, "0")}:${register.subtract(Duration(hours: 3)).minute.toString().padLeft(2, "0")}",
                        delay: register.difference(expected).inMinutes,
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminUseBar(
        onHomePressed: () {},
        onReportPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.AdminReport);
        },
        onSettingsPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.AdminSettings);
        },
      ),
    );
  }
}
