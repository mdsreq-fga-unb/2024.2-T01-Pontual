import 'package:flutter/material.dart';
import 'package:frontend/api/classes_handler.dart';
import 'package:frontend/routes/app_routes.dart';
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

  void fetchClasses() {
    final DateTime startDate = DateTime.now().subtract(Duration(days: 2));
    final startYear = startDate.year.toString();
    final startMonth = startDate.month.toString().padLeft(2, "0");
    final startDay = startDate.day.toString().padLeft(2, "0");

    final DateTime endDate = DateTime.now().add(Duration(days: 2));
    final endYear = endDate.year.toString();
    final endMonth = endDate.month.toString().padLeft(2, "0");
    final endDay = endDate.day.toString().padLeft(2, "0");

    ClassesHandler()
        .getByRange(
            "$startYear-$startMonth-${startDay}T00:00:00",
            "$endYear-$endMonth-${endDay}T23:59:59",
            context.read<UserProvider>().accessToken)
        .then((value) {
      setState(() {
        classes = value;
      });
    }).catchError((error) {});
  }

  @override
  void initState() {
    super.initState();
    fetchClasses();
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
            classes.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
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
                      final start =
                          DateTime(year, month, day, startHour, startMin);

                      int? statusId;
                      String? notes;
                      DateTime? startRegister, endRegister;
                      if (item["days"].contains(datetimeCard.weekday)) {
                        for (var i = 0; i < item["status"].length; i++) {
                          final registerList = item["status"][i]["register"];
                          final expectedList = item["status"][i]["expected"];

                          final startStatus =
                              DateTime.parse(expectedList[0]).toLocal();
                          final endStatus =
                              DateTime.parse(expectedList[1]).toLocal();

                          if (start == startStatus) {
                            statusId = item["status"][i]["id"];
                            notes = item["status"][i]["notes"];
                            if (registerList is List &&
                                registerList.isNotEmpty) {
                              startRegister =
                                  DateTime.parse(registerList[0]).toLocal();

                              if (registerList.length > 1 && end == endStatus) {
                                endRegister =
                                    DateTime.parse(registerList[1]).toLocal();
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
                      return null;
                    },
                  ),
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
            // TURMAS
          ],
        ),
      ),
      bottomNavigationBar: UseBar(
        onHomePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.Home);
        },
        onProfilePressed: () {
          Navigator.of(context).pushNamed(AppRoutes.Profile);
        },
      ),
    );
  }
}
