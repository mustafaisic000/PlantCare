import 'package:plantcare_desktop/models/korisnici_model.dart';
import 'package:plantcare_desktop/models/subkategorije_model.dart';
import 'package:plantcare_desktop/models/kategorija_model.dart';
import 'package:plantcare_desktop/common/config/table_column_config.dart';
import 'package:plantcare_desktop/models/obavijesti_model.dart';
import 'package:plantcare_desktop/models/post_model.dart';
import 'package:plantcare_desktop/models/katalog_model.dart';
import 'package:plantcare_desktop/models/report_model.dart';

List<TableColumnConfig<Korisnik>> getKorisnikTableConfig() {
  return [
    TableColumnConfig(key: 'ime', label: 'Ime', valueBuilder: (k) => k.ime),
    TableColumnConfig(
      key: 'prezime',
      label: 'Prezime',
      valueBuilder: (k) => k.prezime,
    ),
    TableColumnConfig(
      key: 'korisnickoIme',
      label: 'Korisničko ime',
      valueBuilder: (k) => k.korisnickoIme,
    ),
    TableColumnConfig(
      key: 'email',
      label: 'Email',
      valueBuilder: (k) => k.email ?? '',
    ),
    TableColumnConfig(
      key: 'ulogaNaziv',
      label: 'Uloga',
      valueBuilder: (k) => k.ulogaNaziv,
    ),
  ];
}

List<TableColumnConfig<Subkategorija>> getSubkategorijaTableConfig() {
  return [
    TableColumnConfig(
      key: 'naziv',
      label: 'Naziv',
      valueBuilder: (s) => s.naziv,
    ),
    TableColumnConfig(
      key: 'kategorijaNaziv',
      label: 'Kategorija',
      valueBuilder: (s) => s.kategorijaNaziv ?? '',
    ),
  ];
}

List<TableColumnConfig<Kategorija>> getKategorijaTableConfig() {
  return [
    TableColumnConfig(
      key: 'naziv',
      label: 'Naziv',
      valueBuilder: (k) => k.naziv,
    ),
  ];
}

List<TableColumnConfig<Obavijest>> getObavijestTableConfig() {
  return [
    TableColumnConfig(
      key: 'naslov',
      label: 'Naslov',
      valueBuilder: (o) => o.naslov,
    ),
    TableColumnConfig(
      key: 'sadrzaj',
      label: 'Sadržaj',
      valueBuilder: (o) =>
          o.sadrzaj.length > 50 ? '${o.sadrzaj.substring(0, 30)}…' : o.sadrzaj,
    ),
    TableColumnConfig(
      key: 'aktivan',
      label: 'Objavljena',
      valueBuilder: (o) => o.aktivan ? 'Da' : 'Ne',
    ),
    TableColumnConfig(
      key: 'korisnickoIme',
      label: 'Korisnik',
      valueBuilder: (o) => o.korisnickoIme,
    ),
  ];
}

List<TableColumnConfig<Post>> getPostTableConfig() {
  return [
    TableColumnConfig(
      key: 'naslov',
      label: 'Naslov',
      valueBuilder: (p) => p.naslov,
    ),
    TableColumnConfig(
      key: 'sadrzaj',
      label: 'Sadržaj',
      valueBuilder: (p) =>
          p.sadrzaj.length > 10 ? '${p.sadrzaj.substring(0, 10)}…' : p.sadrzaj,
    ),
    TableColumnConfig(
      key: 'premium',
      label: 'Premium',
      valueBuilder: (p) => p.premium ? 'Da' : 'Ne',
    ),
    TableColumnConfig(
      key: 'subkategorijaNaziv',
      label: 'Subkategorija',
      valueBuilder: (p) => p.subkategorijaNaziv,
    ),
    TableColumnConfig(
      key: 'korisnickoIme',
      label: 'Korisnik',
      valueBuilder: (p) => p.korisnickoIme,
    ),
  ];
}

List<TableColumnConfig<Katalog>> getKatalogTableConfig() {
  return [
    TableColumnConfig(
      key: 'naslov',
      label: 'Naslov',
      valueBuilder: (k) => k.naslov,
    ),
    TableColumnConfig(
      key: 'opis',
      label: 'Opis',
      valueBuilder: (k) {
        final opis = k.opis ?? '';
        return opis.length > 15 ? '${opis.substring(0, 15)}…' : opis;
      },
    ),

    TableColumnConfig(
      key: 'aktivan',
      label: 'Aktivan',
      valueBuilder: (k) => k.aktivan ? 'Da' : 'Ne',
    ),
    TableColumnConfig(
      key: 'korisnickoIme',
      label: 'Korisnik',
      valueBuilder: (k) => k.korisnickoIme,
    ),
  ];
}

List<TableColumnConfig<Report>> getReportTableConfig() {
  return [
    TableColumnConfig(
      key: 'postNaslov',
      label: 'Post',
      valueBuilder: (r) => r.postNaslov,
    ),
    TableColumnConfig(
      key: 'korisnickoIme',
      label: 'Korisnik',
      valueBuilder: (r) => r.korisnickoIme,
    ),
    TableColumnConfig(
      key: 'brojLajkova',
      label: 'Lajkova',
      valueBuilder: (r) => r.brojLajkova.toString(),
    ),
    TableColumnConfig(
      key: 'brojOmiljenih',
      label: 'Omiljenih',
      valueBuilder: (r) => r.brojOmiljenih.toString(),
    ),
    TableColumnConfig(
      key: 'brojKomentara',
      label: 'Komentara',
      valueBuilder: (r) => r.brojKomentara.toString(),
    ),
    TableColumnConfig(
      key: 'datum',
      label: 'Datum',
      valueBuilder: (r) =>
          '${r.datum.day.toString().padLeft(2, '0')}.${r.datum.month.toString().padLeft(2, '0')}.${r.datum.year}',
    ),
  ];
}
