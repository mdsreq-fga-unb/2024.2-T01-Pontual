import 'package:flutter/material.dart';
import 'package:frontend/api/classes_handler.dart';
import 'package:frontend/api/status_handler.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/utils/dialog_functions.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/date_card.dart';
import 'package:frontend/widgets/time_card.dart';
import 'package:frontend/widgets/usebar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime datetimeCard = DateTime.now();
  int focusCard = 2;

  List<dynamic> classes = [];
  List<dynamic> vipClasses = [];
  List<dynamic> specialClasses = [];

  List<String> getYearMonthDay() {
    final DateTime startDate = DateTime.now().subtract(Duration(days: 2));
    final startYear = startDate.year.toString();
    final startMonth = startDate.month.toString().padLeft(2, "0");
    final startDay = startDate.day.toString().padLeft(2, "0");

    final DateTime endDate = DateTime.now().add(Duration(days: 2));
    final endYear = endDate.year.toString();
    final endMonth = endDate.month.toString().padLeft(2, "0");
    final endDay = endDate.day.toString().padLeft(2, "0");

    return [startYear, startMonth, startDay, endYear, endMonth, endDay];
  }

  List<dynamic> getStartEnd(dynamic item, int year, int month, int day) {
    DateTime? startRegister, endRegister;
    final registerList = item["register"];
    final expectedList = item["expected"];

    final startTime = expectedList[0].substring(11);
    final endTime = expectedList[1].substring(11);

    final endHour = int.parse(endTime.substring(0, 2));
    final endMin = int.parse(endTime.substring(3, 5));
    final end = DateTime(year, month, day, endHour, endMin);

    final startHour = int.parse(startTime.substring(0, 2));
    final startMin = int.parse(startTime.substring(3, 5));
    final start = DateTime(year, month, day, startHour, startMin);

    final startStatus = DateTime.parse(expectedList[0]).toLocal();
    final endStatus = DateTime.parse(expectedList[1]).toLocal();

    if (start == startStatus) {
      if (registerList is List && registerList.isNotEmpty) {
        startRegister = DateTime.parse(registerList[0]).toLocal();

        if (registerList.length > 1 && end == endStatus) {
          endRegister = DateTime.parse(registerList[1]).toLocal();
        }
      }
    }

    return [start, end, startRegister, endRegister];
  }

  void fetchClasses() {
    final [
      startYear,
      startMonth,
      startDay,
      endYear,
      endMonth,
      endDay,
    ] = getYearMonthDay();

    ClassesHandler()
        .getByRange(
            "$startYear-$startMonth-${startDay}T00:00:00",
            "$endYear-$endMonth-${endDay}T23:59:59",
            context.read<UserProvider>().accessToken)
        .then((value) {
      setState(() {
        classes = value;

        List<dynamic> specialClassesModified = [];
        for (var i = 0; i < classes.length; i++) {
          for (var j = 0; j < classes[i]["status"].length; j++) {
            if (classes[i]["status"][j]["kind"] == "rep") {
              dynamic specialClass = classes[i]["status"][j];
              specialClass["name"] =
                  "Reposição:\n${getClassAsString(classes[i])}";
              specialClass["class__id"] = classes[i]["id"];

              specialClassesModified.add(specialClass);
            }
          }
        }
        specialClasses = specialClassesModified;
      });
    }).catchError((error) {});
  }

  void fetchVipStatus() {
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
            tp: "vip")
        .then((value) {
      setState(() {
        vipClasses = value;
      });
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();
    fetchClasses();
    fetchVipStatus();
  }

  void setFocusCard(int index) {
    setState(() {
      focusCard = index;
    });
  }

  void setDatetimeCard(DateTime datetime) {
    setState(() {
      datetimeCard = datetime;
    });
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
                setFocusCard: setFocusCard,
                setDatetimeCard: setDatetimeCard),
            SizedBox(height: 16),
            Text('Registro de Ponto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ListView.builder(
              itemCount: classes.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = classes[index];

                final startTime = item["start_time"].substring(0, 5);
                final endTime = item["end_time"].substring(0, 5);

                final year = datetimeCard.year;
                final month = datetimeCard.month;
                final day = datetimeCard.day;

                final endHour = int.parse(endTime.substring(0, 2));
                final endMin = int.parse(endTime.substring(3, 5));
                final end = DateTime(year, month, day, endHour, endMin);

                final startHour = int.parse(startTime.substring(0, 2));
                final startMin = int.parse(startTime.substring(3, 5));
                final start = DateTime(year, month, day, startHour, startMin);

                int? statusId;
                String? notes;
                DateTime? startRegister, endRegister;
                if (item["days"].contains(datetimeCard.weekday)) {
                  for (var i = 0; i < item["status"].length; i++) {
                    if (item["status"][i]["kind"] == "std") {
                      final registerList = item["status"][i]["register"];
                      final expectedList = item["status"][i]["expected"];

                      final startStatus =
                          DateTime.parse(expectedList[0]).toLocal();
                      final endStatus =
                          DateTime.parse(expectedList[1]).toLocal();

                      if (start == startStatus) {
                        statusId = item["status"][i]["id"];
                        notes = item["status"][i]["notes"];
                        if (registerList is List && registerList.isNotEmpty) {
                          startRegister =
                              DateTime.parse(registerList[0]).toLocal();

                          if (registerList.length > 1 && end == endStatus) {
                            endRegister =
                                DateTime.parse(registerList[1]).toLocal();
                          }
                        }
                      }
                    }
                  }

                  return TimeCardWidget(
                    id: item["id"],
                    statusId: statusId,
                    title: item["name"],
                    startTime: start,
                    endTime: end,
                    statusMessage: notes,
                    startRegister: startRegister,
                    endRegister: endRegister,
                    updateClasses: fetchClasses,
                  );
                }
                return Container();
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Turmas Especiais',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListView.builder(
              itemCount: specialClasses.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = specialClasses[index];
                final expected = DateTime(
                    int.parse(item["expected"][0].substring(0, 4)),
                    int.parse(item["expected"][0].substring(5, 7)),
                    int.parse(item["expected"][0].substring(8, 10)));

                final year = datetimeCard.year;
                final month = datetimeCard.month;
                final day = datetimeCard.day;

                if (expected == DateTime(year, month, day)) {
                  final [
                    start,
                    end,
                    startRegister,
                    endRegister,
                  ] = getStartEnd(item, year, month, day);

                  return TimeCardWidget(
                    id: item["class__id"],
                    kind: item["kind"],
                    statusId: item["id"],
                    title: item["name"],
                    statusMessage: item["notes"],
                    startTime: start,
                    endTime: end,
                    startRegister: startRegister,
                    endRegister: endRegister,
                    updateClasses: fetchClasses,
                  );
                }
                return Container();
              },
            ),
            ListView.builder(
              itemCount: vipClasses.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = vipClasses[index];
                final expected = DateTime(
                    int.parse(item["expected"][0].substring(0, 4)),
                    int.parse(item["expected"][0].substring(5, 7)),
                    int.parse(item["expected"][0].substring(8, 10)));

                final year = datetimeCard.year;
                final month = datetimeCard.month;
                final day = datetimeCard.day;

                if (expected == DateTime(year, month, day)) {
                  final [
                    start,
                    end,
                    startRegister,
                    endRegister,
                  ] = getStartEnd(item, year, month, day);

                  return TimeCardWidget(
                    kind: item["kind"],
                    statusId: item["id"],
                    title: "VIP",
                    statusMessage: item["notes"],
                    startTime: start,
                    endTime: end,
                    startRegister: startRegister,
                    endRegister: endRegister,
                    updateClasses: fetchVipStatus,
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: UseBar(
        updateClasses: fetchClasses,
        updateVIP: fetchVipStatus,
        onHomePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.Home);
        },
        onProfilePressed: () async {
          Navigator.of(context).pushNamed(AppRoutes.Profile);
        },
      ),
    );
  }
}
