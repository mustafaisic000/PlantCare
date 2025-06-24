import 'package:flutter/material.dart';

typedef GetRowValue<T> = String Function(T item, String columnKey);
typedef RowAction<T> = void Function(T item);

class GenericPaginatedTable<T> extends StatelessWidget {
  final List<T> data;
  final List<String> columns;
  final GetRowValue<T> getValue;
  final RowAction<T>? onView;
  final RowAction<T>? onEdit;
  final RowAction<T>? onDelete;

  final int rowsPerPage;
  final int currentPage;
  final void Function(int newPage) onPageChanged;

  const GenericPaginatedTable({
    super.key,
    required this.data,
    required this.columns,
    required this.getValue,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onPageChanged,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final visibleData = data.sublist(start, end);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowHeight: 48,
                  dataRowMinHeight: 48,
                  columnSpacing: 48,
                  columns: [
                    ...columns.map(
                      (col) => DataColumn(
                        label: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(col),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(alignment: Alignment.centerRight),
                    ),
                  ],
                  rows: visibleData.map((item) {
                    return DataRow(
                      cells: [
                        ...columns.map(
                          (col) => DataCell(
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(getValue(item, col)),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (onView != null)
                                  IconButton(
                                    icon: const Icon(Icons.visibility),
                                    onPressed: () => onView!(item),
                                  ),
                                if (onEdit != null)
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => onEdit!(item),
                                  ),
                                if (onDelete != null)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => onDelete!(item),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${start + 1}–$end of ${data.length}'),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: currentPage > 0
                      ? () => onPageChanged(currentPage - 1)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: end < data.length
                      ? () => onPageChanged(currentPage + 1)
                      : null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
