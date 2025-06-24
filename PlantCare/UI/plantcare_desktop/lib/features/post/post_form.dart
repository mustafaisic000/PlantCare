import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/post_model.dart';
import 'package:plantcare_desktop/providers/post_provider.dart';
import 'package:plantcare_desktop/providers/subkategorije_provider.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final bool readOnly;
  final VoidCallback? onClose;

  const PostForm({super.key, this.post, this.readOnly = false, this.onClose});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  final naslovController = TextEditingController();
  final sadrzajController = TextEditingController();

  final PostProvider provider = PostProvider();
  final SubkategorijaProvider subProvider = SubkategorijaProvider();

  int? subkategorijaId;
  Uint8List? imageData;
  String? originalSlika;
  List<DropdownMenuItem<int>> subOptions = [];

  bool premium = false;

  @override
  void initState() {
    super.initState();
    loadSubkategorije();

    if (widget.post != null) {
      final p = widget.post!;
      naslovController.text = p.naslov;
      sadrzajController.text = p.sadrzaj;
      subkategorijaId = p.subkategorijaId;
      premium = p.premium;
      originalSlika = p.slika;
    }
  }

  Future<void> loadSubkategorije() async {
    final result = await subProvider.get();
    setState(() {
      subOptions = result.result.map((e) {
        return DropdownMenuItem<int>(
          value: e.subkategorijaId,
          child: Text(e.naziv),
        );
      }).toList();
    });
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      Uint8List? bytes = result.files.single.bytes;
      if (bytes == null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        bytes = await file.readAsBytes();
      }
      if (bytes != null) {
        setState(() => imageData = bytes);
      }
    }
  }

  Widget buildImagePreview() {
    Widget imageWidget;
    if (imageData != null) {
      imageWidget = Image.memory(imageData!, fit: BoxFit.cover);
    } else if (originalSlika != null && originalSlika!.isNotEmpty) {
      try {
        final decoded = base64Decode(originalSlika!);
        imageWidget = Image.memory(decoded, fit: BoxFit.cover);
      } catch (_) {
        imageWidget = Image.asset(
          'assets/images/placeholder.png',
          fit: BoxFit.cover,
        );
      }
    } else {
      imageWidget = Image.asset(
        'assets/images/placeholder.png',
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: 200,
      height: 220,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: imageWidget,
    );
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    final postMap = {
      'naslov': naslovController.text,
      'sadrzaj': sadrzajController.text,
      'premium': premium,
      'subkategorijaId': subkategorijaId,
      'korisnikId': 1,
      'slika': imageData != null
          ? base64Encode(imageData!)
          : originalSlika ?? '',
    };

    if (widget.post == null) {
      await provider.insert(postMap);
    } else {
      await provider.update(widget.post!.postId, postMap);
    }

    if (!mounted) return;
    Navigator.pop(context);
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF4EFEA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.post == null ? "Dodaj post" : "Uredi post",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      buildImagePreview(),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: widget.readOnly ? null : pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text("Dodaj sliku"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF50C878),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: naslovController,
                          readOnly: widget.readOnly,
                          decoration: const InputDecoration(
                            labelText: "Naslov",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Unesite naslov";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: subkategorijaId,
                                items: subOptions,
                                onChanged: widget.readOnly
                                    ? null
                                    : (val) =>
                                          setState(() => subkategorijaId = val),
                                decoration: const InputDecoration(
                                  labelText: "Subkategorija",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) => val == null
                                    ? "Odaberi subkategoriju"
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Checkbox(
                              value: premium,
                              onChanged: widget.readOnly
                                  ? null
                                  : (val) => setState(() => premium = val!),
                            ),
                            const Text("Premium post"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: sadrzajController,
                          maxLines: 4,
                          readOnly: widget.readOnly,
                          decoration: const InputDecoration(
                            labelText: "Sadržaj",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Unesite sadržaj";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: widget.readOnly ? null : save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF50C878),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Sačuvaj"),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Odustani"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
