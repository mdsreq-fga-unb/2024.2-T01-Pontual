import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportTable extends StatefulWidget {
  final dynamic report;
  final bool isEditable;
  final List<bool> toggles;

  static int numberOfRows = 0;

  const ReportTable({
    super.key,
    required this.report,
    this.isEditable = false,
    this.toggles = const [],
  });

  @override
  _ReportTableState createState() => _ReportTableState();
}

class _ReportTableState extends State<ReportTable> {
  static const rowPrimaryColor = Color(0xFFEDEDED);
  static const rowSecondaryColor = Color(0xFFD9D9D9);

  List<Widget Function(bool)> generateRowWidgets(List<dynamic> row) {
    return row.map((cell) {
      return (bool isHeader) {
        if (cell is Widget) {
          return cell;
        }
        return Center(
          child: Padding(
            padding: EdgeInsets.all(isHeader ? 5 : 7),
            child: Text(
              cell,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isHeader ? 14 : (widget.isEditable ? 10 : 12),
              ),
            ),
          ),
        );
      };
    }).toList();
  }

  TableRow buildTableRow(List<Widget Function(bool)> data,
      {bool isHeader = false, Color? color, bool isLast = false}) {
    ReportTable.numberOfRows++;

    Color rowColor = (ReportTable.numberOfRows % 2 == 0
        ? rowPrimaryColor
        : rowSecondaryColor);

    if (isLast) {
      ReportTable.numberOfRows = 0;
    }

    return TableRow(
      decoration: isHeader
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5),
              ),
              color: color ?? (isHeader ? rowPrimaryColor : rowColor),
            )
          : BoxDecoration(
              color: color ?? (isHeader ? rowPrimaryColor : rowColor),
            ),
      children: data
          .map(
            (cell) => cell(isHeader),
          )
          .toList(),
    );
  }

  List<Widget> generateReport() {
    int index = 0;

    List<Widget> reportTable = [];

    for (var info in widget.report["report"]) {
      if (info["statuses"].isEmpty) {
        continue;
      }

      reportTable.add(
        Text(
          info["date"],
          style: TextStyle(fontSize: 16),
        ),
      );
      reportTable.add(SizedBox(height: 10));

      List<TableRow> rows = [];
      for (var i = 0; i < info["statuses"].length; i++) {
        var status = info["statuses"][i];
        String? comment = status["comment"] != null
            ? status["comment"][0].toUpperCase() +
                status["comment"].substring(1)
            : null;

        DateFormat format = DateFormat("dd/MM/yyyy HH:mm");

        DateTime entry = format.parse(status["entry"]);
        DateTime leave = format.parse(status["leave"]);

        int nightsEntryLeave = leave.difference(entry).inDays;
        if (leave.day != entry.day) {
          nightsEntryLeave += 1;
        }

        List<dynamic> row = [
          status["class"],
          "${status["entry"].substring(11)}",
          "${status["leave"].substring(11)} ${nightsEntryLeave > 0 ? "+$nightsEntryLeave" : ""}",
          status["entry_report"] != null
              ? "${status["entry_report"].substring(0, 5)}\n${status["entry_report"].substring(11)}"
              : (comment ?? "-"),
          status["leave_report"] != null
              ? "${status["leave_report"].substring(0, 5)}\n${status["leave_report"].substring(11)}"
              : "-",
        ];

        if (widget.isEditable) {
          var tmp = index;
          row.add(Checkbox(
            value: widget.toggles[tmp],
            onChanged: (bool? newValue) {
              setState(() {
                widget.toggles[tmp] = newValue!;
              });
            },
          ));
          index++;
        }

        rows.add(
          buildTableRow(
            generateRowWidgets(row),
            color: comment == null ? null : Color(0xFFDDBBBB),
            isLast: i == info["statuses"].length - 1,
          ),
        );
      }

      List<String> headers = ["Aula", "Entrada", "Saída", "Entrou", "Saiu"];
      if (widget.isEditable) {
        headers.add("Editar");
      }

      reportTable.add(
        Table(
          border: TableBorder(
            top: BorderSide(width: 1.5),
          ),
          children: [
            buildTableRow(
              generateRowWidgets(headers),
              isHeader: true,
            ),
            ...rows,
          ],
        ),
      );
      reportTable.add(SizedBox(height: 20));
    }

    return reportTable;
  }

  @override
  Widget build(BuildContext context) {
    ReportTable.numberOfRows = 0;
    
    return Column(
      children: generateReport(),
    );
  }
}
