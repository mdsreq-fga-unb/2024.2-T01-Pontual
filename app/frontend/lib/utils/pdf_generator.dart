import 'dart:typed_data';
import 'dart:html' as html;

import 'package:frontend/screen/profile_screen.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:frontend/api/report_handler.dart';
import 'package:frontend/utils/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:archive/archive.dart';

void downloadPDFs(List<List<int>> pdfFiles, List<String> names,
    {bool zip = true}) {
  if (zip) {
    final archive = Archive();

    for (int i = 0; i < pdfFiles.length; i++) {
      archive.addFile(
          ArchiveFile('${names[i]}.pdf', pdfFiles[i].length, pdfFiles[i]));
    }

    final zipData = ZipEncoder().encode(archive);

    final blob = html.Blob([Uint8List.fromList(zipData)]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'relatorios.zip';
    anchor.click();

    html.Url.revokeObjectUrl(url);
  } else {
    for (int i = 0; i < pdfFiles.length; i++) {
      final blob = html.Blob([Uint8List.fromList(pdfFiles[i])]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = '${names[i]}.pdf';
      anchor.click();

      html.Url.revokeObjectUrl(url);
    }
  }
}

Future<Uint8List> generateReportPDF(
    BuildContext context, int reportId, dynamic user) async {
  final pdf = pw.Document();

  dynamic report = await ReportHandler().get(
    context.read<UserProvider>().accessToken,
    id: reportId,
  );

  String title = ProfileScreen.getReportTitle(report, withBreak: false);

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Relatório: $title\nFuncionário: ${user["name"]}',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Horas Totais: ${report["total_minutes"] != null ? "${(report["total_minutes"] ~/ 60).toString().padLeft(2, "0")}:${(report["total_minutes"] % 60).toString().padLeft(2, "0")}" : "N/A"}',
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Faltas: ${report["absences"] ?? "N/A"}',
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 15),
            pw.Text(
              'Detalhes do Relatório:',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.ListView.builder(
              itemCount: report['report'].length,
              direction: pw.Axis.vertical,
              spacing: 10,
              itemBuilder: (context, index) {
                var value = report['report'][index];

                return value['statuses'].length == 0
                    ? pw.SizedBox()
                    : pw.Column(
                        children: [
                          pw.Text(
                            '${value['date'][0].toUpperCase()}${value['date'].substring(1)}',
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.TableHelper.fromTextArray(
                            headers: [
                              'Aula',
                              'Entrada',
                              'Saída',
                              'Entrou',
                              'Saiu'
                            ],
                            data: List<List<String>>.generate(
                              value['statuses'].length,
                              (index) {
                                var row = value['statuses'][index];
                                return [
                                  row['class'],
                                  row['entry'],
                                  row['leave'],
                                  row['entry_report'] ??
                                      row['comment'].toUpperCase(),
                                  row['leave_report'] ?? "",
                                ];
                              },
                            ),
                            border: pw.TableBorder.all(width: 1),
                            cellAlignment: pw.Alignment.center,
                          )
                        ],
                      );
              },
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Status de Revisão: ${report['reviewed'] ? "Revisado" : "Não Revisado"}',
              style: pw.TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    ),
  );

  return await pdf.save();
}
