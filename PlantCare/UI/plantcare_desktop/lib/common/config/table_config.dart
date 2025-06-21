import 'package:plantcare_desktop/models/korisnici_model.dart';
import 'package:plantcare_desktop/common/config/table_column_config.dart';

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
      key: 'telefon',
      label: 'Telefon',
      valueBuilder: (k) => k.telefon ?? '',
    ),
    TableColumnConfig(
      key: 'ulogaNaziv',
      label: 'Uloga',
      valueBuilder: (k) => k.ulogaNaziv,
    ),
  ];
}
