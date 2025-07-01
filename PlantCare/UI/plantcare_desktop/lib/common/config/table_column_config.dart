class TableColumnConfig<T> {
  final String key;
  final String label;
  final String Function(T item)? valueBuilder;

  TableColumnConfig({
    required this.key,
    required this.label,
    this.valueBuilder,
  });
}
