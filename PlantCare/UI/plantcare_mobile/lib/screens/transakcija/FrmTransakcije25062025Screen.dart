import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantcare_mobile/models/kategorije_transakcije2025_model.dart';
import 'package:plantcare_mobile/models/stat_kategorija_model.dart';
import 'package:plantcare_mobile/models/transakcija25062025_model.dart';
import 'package:plantcare_mobile/providers/kategorije_transakcije2025_provider.dart';
import 'package:plantcare_mobile/providers/transakcija25062025_provider.dart';
import 'package:plantcare_mobile/providers/util.dart';

class FrmTransakcije25062025Screen extends StatefulWidget {
  const FrmTransakcije25062025Screen({super.key});

  @override
  State<FrmTransakcije25062025Screen> createState() =>
      _FrmTransakcije25062025ScreenState();
}

class _FrmTransakcije25062025ScreenState
    extends State<FrmTransakcije25062025Screen> {
  final KategorijeTransakcije2025Provider _kategorijeTransakcije2025Provider =
      KategorijeTransakcije2025Provider();
  final Transakcija25062025Provider _transakcije2025provider =
      Transakcija25062025Provider();

  List<KategorijeTransakcije2025> _listaKategorija = [];
  List<Transakcija25062025> _listaTransakcija = [];
  List<StatKategorija> _listaStatistike = [];

  DateTime? datumOD;
  DateTime? datumDO;
  KategorijeTransakcije2025? _selectedKAtegorija;

  @override
  void initState() {
    super.initState();
    _fetchPodaci();
  }

  void _fetchPodaci() async {
    final responseT = await Transakcija25062025Provider().get();
    final responseK = await KategorijeTransakcije2025Provider().get();
    final responseStat = await Transakcija25062025Provider().getStat(
      filter: {
        "KategorijaTransakcije25062025Id":
            _selectedKAtegorija?.kategorijaTransakcije25062025Id,
      },
    );

    setState(() {
      _listaTransakcija = responseT.result;
      _listaKategorija = responseK.result;
      _listaStatistike = responseStat;
    });
  }

  void _filterPodaci() async {
    final responseT = await Transakcija25062025Provider().get(
      filter: {
        'KategorijaTransakcije25062025Id':
            _selectedKAtegorija?.kategorijaTransakcije25062025Id,
        'DatumTransakcijeOD': datumOD,
        'DatumTransakcijeOD': datumDO,
      },
    );
    final responseStat = await Transakcija25062025Provider().getStat(
      filter: {
        "KategorijaTransakcije25062025Id":
            _selectedKAtegorija?.kategorijaTransakcije25062025Id,
      },
    );

    setState(() {
      _listaTransakcija = responseT.result;
      _listaStatistike = responseStat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transakcije25062025")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _dodajDugme(),
            const SizedBox(height: 16),
            _dropDownFilter(),
            const SizedBox(height: 16),
            _dateTimePickeri(),
            const SizedBox(height: 16),
            _tableView(),
            const SizedBox(height: 16),
            _tableStatistika(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _dropDownFilter() {
    return DropdownButtonFormField<KategorijeTransakcije2025>(
      decoration: const InputDecoration(
        labelText: "Unesite kategoriju",
        border: OutlineInputBorder(),
      ),
      value: _selectedKAtegorija,
      onChanged: (value) {
        setState(() {
          _selectedKAtegorija = value;
        });
        _filterPodaci();
      },
      items: _listaKategorija.map((e) {
        return DropdownMenuItem(value: e, child: Text(e.nazivKategorije));
      }).toList(),
    );
  }

  Widget _tableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Opis")),
          DataColumn(label: Text("Korisnik")),
          DataColumn(label: Text("Ime kategorije")),
          DataColumn(label: Text("Datum")),
          DataColumn(label: Text("Status")),
        ],
        rows: _listaTransakcija.map((e) {
          return DataRow(
            cells: [
              DataCell(Text(e.opis)),
              DataCell(Text(e.korisnik!.korisnickoIme)),
              DataCell(Text(e.kategorijaTransakcije25062025!.nazivKategorije)),
              DataCell(Text(formatDate(e.datumTransakcije))),
              DataCell(Text(e.status)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _tableStatistika() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        ..._listaStatistike.map((e) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("${e.getNaziv}"), Text("${e.iznos}")],
          );
        }).toList(),
      ],
    );
  }

  Widget _dateTimePickeri() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: datumOD ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  datumOD = picked;
                });
                _filterPodaci();
              }
            },
            child: Text(
              datumOD == null
                  ? "Datum OD"
                  : "Datum OD: ${DateFormat('dd.MM.yyyy').format(datumOD!)}",
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: datumDO ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  datumDO = picked;
                });
                _filterPodaci();
              }
            },
            child: Text(
              datumDO == null
                  ? "DatumTransakcijeDO"
                  : "DatumTransakcijeDO: ${DateFormat('dd.MM.yyyy').format(datumDO!)}",
            ),
          ),
        ),
      ],
    );
  }
}
