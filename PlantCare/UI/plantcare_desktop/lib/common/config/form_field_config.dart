enum FieldType { text, email, number, date, dropdown }

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
