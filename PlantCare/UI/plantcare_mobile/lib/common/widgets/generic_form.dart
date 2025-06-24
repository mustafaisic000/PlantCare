import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/config/form_field_config.dart';
import 'package:plantcare_desktop/providers/util.dart';
import 'package:plantcare_desktop/providers/uloga_provider.dart';

class GenericForm extends StatefulWidget {
  final List<FormFieldConfig> config;
  final Map<String, dynamic> initialData;
  final void Function(Map<String, dynamic>) onSubmit;
  final bool isLoading;
  final bool readOnly;
  final GlobalKey<FormState>? formKey;

  const GenericForm({
    required this.config,
    required this.initialData,
    required this.onSubmit,
    this.isLoading = false,
    this.readOnly = false,
    this.formKey,
    super.key,
  });

  @override
  State<GenericForm> createState() => _GenericFormState();
}

class _GenericFormState extends State<GenericForm> {
  late Map<String, TextEditingController> controllers;
  final _internalFormKey = GlobalKey<FormState>();
  Map<String, List<Map<String, String>>> dynamicDropdownOptions = {};
  String? base64Image;

  @override
  void initState() {
    super.initState();
    controllers = {
      for (var field in widget.config)
        if (field.type != FieldType.image)
          field.key: TextEditingController(
            text: _initialValue(field.key, field.type),
          ),
    };
    base64Image = widget.initialData['slika'];
    _loadDynamicDropdowns();
  }

  Future<void> _loadDynamicDropdowns() async {
    for (var field in widget.config) {
      if (field.key == 'ulogaId') {
        final provider = UlogaProvider();
        final uloge = await provider.get();
        dynamicDropdownOptions['ulogaId'] = uloge.result
            .map((e) => {'value': e.ulogaId.toString(), 'label': e.naziv})
            .toList();
        setState(() {});
      }
    }
  }

  String _initialValue(String key, FieldType type) {
    final value = widget.initialData[key];
    if (value == null) return '';
    if (type == FieldType.date) {
      final parsed = DateTime.tryParse(value.toString());
      return parsed != null ? formatDate(parsed) : '';
    }
    return value.toString();
  }

  void _submit() {
    final formKey = widget.formKey ?? _internalFormKey;
    if (formKey.currentState!.validate()) {
      final data = {
        for (var field in widget.config)
          if (field.type != FieldType.image)
            field.key: field.type == FieldType.date
                ? controllers[field.key]!.text
                : controllers[field.key]!.text.trim(),
      };
      if (widget.config.any((f) => f.type == FieldType.image)) {
        data['slika'] = base64Image ?? '';
      }
      widget.onSubmit(data);
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        base64Image = base64Encode(result.files.single.bytes!);
      });
    }
  }

  Widget _buildField(FormFieldConfig field) {
    if (field.type == FieldType.image) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (base64Image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(base64Image!),
                    height: 140,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 8),
              if (!widget.readOnly)
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Dodaj sliku'),
                ),
            ],
          ),
        ),
      );
    }

    final controller = controllers[field.key]!;

    if (field.type == FieldType.date) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 16),
          child: GestureDetector(
            onTap: widget.readOnly
                ? null
                : () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      controller.text = formatDate(picked);
                      setState(() {});
                    }
                  },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: field.label,
                  border: const OutlineInputBorder(),
                ),
                validator: field.required && !widget.readOnly
                    ? (value) => value == null || value.isEmpty
                          ? 'Obavezno polje'
                          : null
                    : null,
              ),
            ),
          ),
        ),
      );
    }

    if (field.type == FieldType.dropdown) {
      final options = field.options ?? dynamicDropdownOptions[field.key] ?? [];
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 16),
          child: DropdownButtonFormField<int>(
            value: int.tryParse(controller.text),
            items: options
                .map(
                  (opt) => DropdownMenuItem<int>(
                    value: int.parse(opt['value']!),
                    child: Text(opt['label'] ?? ''),
                  ),
                )
                .toList(),
            onChanged: widget.readOnly
                ? null
                : (val) => controller.text = val?.toString() ?? '',
            decoration: InputDecoration(
              labelText: field.label,
              border: const OutlineInputBorder(),
            ),
            validator: field.required && !widget.readOnly
                ? (value) => value == null ? 'Obavezno polje' : null
                : null,
          ),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: TextFormField(
          controller: controller,
          readOnly: field.readOnly || widget.readOnly,
          decoration: InputDecoration(
            labelText: field.label,
            border: const OutlineInputBorder(),
          ),
          maxLines: field.multiline ? null : 1,
          validator: field.required && !widget.readOnly
              ? (value) =>
                    value == null || value.isEmpty ? 'Obavezno polje' : null
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = widget.formKey ?? _internalFormKey;

    final List<Row> rows = [];
    for (int i = 0; i < widget.config.length; i += 2) {
      final fields = <Widget>[
        _buildField(widget.config[i]),
        if (i + 1 < widget.config.length) _buildField(widget.config[i + 1]),
      ];
      rows.add(
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: fields),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 600),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            ...rows,
            if (!widget.readOnly) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: widget.isLoading ? null : _submit,
                  child: widget.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Sačuvaj"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
