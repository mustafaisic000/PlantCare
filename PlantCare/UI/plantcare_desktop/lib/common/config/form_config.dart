import 'package:plantcare_desktop/common/config/form_field_config.dart';

List<FormFieldConfig> getFormConfig(String type, {bool readOnly = false}) {
  switch (type) {
    case 'korisnik':
      return [
        FormFieldConfig(
          key: 'ime',
          label: 'Ime',
          required: true,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          key: 'prezime',
          label: 'Prezime',
          required: true,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          key: 'email',
          label: 'Email',
          required: true,
          type: FieldType.email,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          key: 'telefon',
          label: 'Telefon',
          required: true,
          type: FieldType.email,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          key: 'datumRodjenja',
          label: 'Datum rođenja',
          type: FieldType.date,
          readOnly: readOnly,
        ),
        FormFieldConfig(
          key: 'ulogaId',
          label: 'Uloga',
          type: FieldType.dropdown,
          readOnly: readOnly,
        ),
      ];
    default:
      return [];
  }
}
