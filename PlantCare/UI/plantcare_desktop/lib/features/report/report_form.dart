import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/post_model.dart';
import 'package:plantcare_desktop/models/report_model.dart';
import 'package:plantcare_desktop/providers/post_provider.dart';
import 'package:plantcare_desktop/providers/report_provider.dart';
import 'package:plantcare_desktop/providers/util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:dropdown_search/dropdown_search.dart';

class ReportForm extends StatefulWidget {
  final Report? report;
  final VoidCallback? onSuccess;

  const ReportForm({super.key, this.report, this.onSuccess});

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final _formKey = GlobalKey<FormState>();
  final PostProvider _postProvider = PostProvider();
  final ReportProvider _reportProvider = ReportProvider();

  int? _selectedPostId;

  bool get isInsertMode => widget.report == null;

  Future<List<Post>> _fetchPostovi(String filter) async {
    final result = await _postProvider.get(filter: {'naslov': filter});
    return result.result;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPostId == null) return;

    await _reportProvider.insert({'postId': _selectedPostId!});

    if (widget.onSuccess != null) widget.onSuccess!();
    Navigator.of(context).pop();
  }

  Future<void> _exportToPdf() async {
    final image = await _screenshotController.capture();
    final doc = pw.Document();
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);
    final r = widget.report!;

    doc.addPage(
      pw.Page(
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Izvještaj za post: ${r.postNaslov}",
              style: pw.TextStyle(fontSize: 20, font: ttf),
            ),
            pw.SizedBox(height: 10),
            if (image != null) pw.Image(pw.MemoryImage(image)),
            pw.SizedBox(height: 10),
            pw.Text(
              "Broj komentara: ${r.brojKomentara}",
              style: pw.TextStyle(font: ttf),
            ),
            pw.Text(
              "Broj lajkova: ${r.brojLajkova}",
              style: pw.TextStyle(font: ttf),
            ),
            pw.Text(
              "Broj omiljenih: ${r.brojOmiljenih}",
              style: pw.TextStyle(font: ttf),
            ),
            pw.Text(
              "Datum: ${formatDate(r.datum)}",
              style: pw.TextStyle(font: ttf),
            ),
          ],
        ),
      ),
    );

    final downloads = Directory(
      path.join((await getDownloadsDirectory())?.path ?? '.', ''),
    );
    final file = File('${downloads.path}/izvjestaj_${r.reportId}.pdf');
    await file.writeAsBytes(await doc.save());

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Uspjeh"),
        content: Text("PDF spremljen u:\n${file.path}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF4EFEA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: isInsertMode ? _buildInsertForm() : _buildViewForm(),
      ),
    );
  }

  Widget _buildInsertForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Dodaj izvještaj",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownSearch<Post>(
            asyncItems: (filter) => _fetchPostovi(filter),
            itemAsString: (post) => post.naslov,
            selectedItem: null,
            onChanged: (post) => _selectedPostId = post?.postId,
            validator: (value) => value == null ? "Odaberite post" : null,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: const InputDecoration(
                labelText: 'Post',
                border: OutlineInputBorder(),
              ),
            ),
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'Pretraži postove...',
                  border: OutlineInputBorder(),
                ),
              ),
              fit: FlexFit.loose,
              constraints: BoxConstraints(maxHeight: 300),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Odustani"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _save, child: const Text("Sačuvaj")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewForm() {
    final r = widget.report!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Detalji izvještaja",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        _buildRow("Post:", r.postNaslov),
        _buildRow("Korisnik:", r.korisnickoIme),
        _buildRow("Datum:", formatDate(r.datum)),
        const SizedBox(height: 20),
        RepaintBoundary(
          child: Screenshot(
            controller: _screenshotController,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: _buildChart(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _exportToPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Preuzmi PDF izvještaj"),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Zatvori"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final r = widget.report!;
    final maxValue = max(r.brojKomentara, max(r.brojLajkova, r.brojOmiljenih));
    final maxY = (maxValue * 1.3).ceilToDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: r.brojKomentara.toDouble(),
                      color: Colors.orange,
                      width: 30,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: r.brojLajkova.toDouble(),
                      color: Colors.green,
                      width: 30,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: r.brojOmiljenih.toDouble(),
                      color: Colors.blue,
                      width: 30,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, _) =>
                        Text(value.toInt().toString()),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text("Komentari");
                        case 1:
                          return const Text("Lajkovi");
                        case 2:
                          return const Text("Omiljeni");
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                      BarTooltipItem(
                        rod.toY.toInt().toString(),
                        const TextStyle(color: Colors.white),
                      ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            _Legend(color: Colors.orange, label: 'Komentari'),
            SizedBox(width: 12),
            _Legend(color: Colors.green, label: 'Lajkovi'),
            SizedBox(width: 12),
            _Legend(color: Colors.blue, label: 'Omiljeni'),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
