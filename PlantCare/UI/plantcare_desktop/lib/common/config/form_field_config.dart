enum FieldType { text, email, number, date, dropdown, image }

class FormFieldConfig {
  final String label;
  final String key;
  final bool required;
  final bool readOnly;
  final bool multiline;
  final FieldType type;
  final List<Map<String, String>>? options;

  FormFieldConfig({
    required this.label,
    required this.key,
    this.required = false,
    this.readOnly = false,
    this.multiline = false,
    this.type = FieldType.text,
    this.options,
  });
}

List<FormFieldConfig> getFormConfig(String type, {bool readOnly = false}) {
  switch (type) {
    case 'korisnik':
      return [
        FormFieldConfig(
          label: 'Ime',
          key: 'ime',
          required: true,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          label: 'Prezime',
          key: 'prezime',
          required: true,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          label: 'Korisničko ime',
          key: 'korisnickoIme',
          required: true,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          label: 'Email',
          key: 'email',
          required: true,
          type: FieldType.email,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          label: 'Telefon',
          key: 'telefon',
          type: FieldType.text,
          required: true,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          label: 'Datum rođenja',
          key: 'datumRodjenja',
          type: FieldType.date,
          required: true,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          label: 'Uloga',
          key: 'ulogaId',
          type: FieldType.dropdown,
          required: true,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          label: 'Profilna slika',
          key: 'slika',
          type: FieldType.image,
        ),
      ];
    default:
      return [];
  }
}
