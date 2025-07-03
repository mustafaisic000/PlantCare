import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/providers/subkategorije_provider.dart';

class DodajPostScreen extends StatefulWidget {
  final Post? post;

  const DodajPostScreen({super.key, this.post});

  @override
  State<DodajPostScreen> createState() => DodajPostScreenState();
}

class DodajPostScreenState extends State<DodajPostScreen> {
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  final _naslovController = TextEditingController();
  final _sadrzajController = TextEditingController();
  bool get isObicanKorisnik => AuthProvider.korisnik?.ulogaId == 3;
  final SubkategorijaProvider _subProvider = SubkategorijaProvider();
  final PostProvider _postProvider = PostProvider();

  Uint8List? imageData;
  String? originalSlika;
  bool showSlikaError = false;
  bool premium = false;
  int? subkategorijaId;
  List<DropdownMenuItem<int>> subOptions = [];
  final ImagePicker _imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _loadDropdowns();
    _sadrzajController.addListener(() => setState(() {}));

    if (widget.post != null) {
      final p = widget.post!;
      _naslovController.text = p.naslov;
      _sadrzajController.text = p.sadrzaj;
      subkategorijaId = p.subkategorijaId;
      premium = p.premium;
      originalSlika = p.slika;

      if (originalSlika != null && originalSlika!.isNotEmpty) {
        try {
          imageData = base64Decode(originalSlika!);
        } catch (_) {
          imageData = null;
        }
      }
    }
  }

  void loadDropdowns() {
    _loadDropdowns();
  }

  Future<void> _loadDropdowns() async {
    final result = await _subProvider.get();
    setState(() {
      subOptions = result.result.map((s) {
        return DropdownMenuItem<int>(
          value: s.subkategorijaId,
          child: Text(s.naziv),
        );
      }).toList();
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (file == null) {
        print("⚠️ Nije odabrana nijedna slika.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nije odabrana nijedna slika.")),
        );
        return;
      }

      final bytes = await file.readAsBytes();
      if (bytes.isNotEmpty) {
        print("✅ Slika učitana: ${bytes.lengthInBytes} bajtova");
        setState(() {
          imageData = bytes;
          showSlikaError = false;
        });
      } else {
        throw Exception("Slika je prazna.");
      }
    } catch (e) {
      print("❌ Greška u pickImage: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Greška pri dodavanju slike.")),
      );
    }
  }

  Widget _buildImage() {
    Widget imageWidget;

    if (imageData != null) {
      imageWidget = Image.memory(imageData!, fit: BoxFit.fill);
    } else {
      imageWidget = Image.asset(
        'assets/images/placeholder.png',
        fit: BoxFit.fill,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.45,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: InkWell(onTap: _pickImage, child: imageWidget),
        ),
        if (showSlikaError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: Text(
                "Slika je obavezna",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _save() async {
    setState(() {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
    });

    final isValid = _formKey.currentState!.validate();
    final hasImage =
        imageData != null ||
        (originalSlika != null && originalSlika!.isNotEmpty);

    setState(() {
      showSlikaError = !hasImage;
    });

    if (!isValid || !hasImage) return;

    final postMap = {
      'naslov': _naslovController.text.trim(),
      'sadrzaj': _sadrzajController.text.trim(),
      'premium': isObicanKorisnik ? false : premium,
      'subkategorijaId': subkategorijaId,
      'korisnikId': AuthProvider.korisnik!.korisnikId,
      'slika': imageData != null ? base64Encode(imageData!) : originalSlika,
    };

    if (widget.post == null) {
      await _postProvider.insert(postMap);
    } else {
      await _postProvider.update(widget.post!.postId, postMap);
      final updatedPost = await _postProvider.getById(widget.post!.postId);
      if (!mounted) return;
      Navigator.of(context).pop(updatedPost);
    }

    if (!mounted) return;

    _formKey.currentState!.reset();
    _naslovController.clear();
    _sadrzajController.clear();
    setState(() {
      imageData = null;
      originalSlika = null;
      premium = false;
      subkategorijaId = null;
      showSlikaError = false;
      _autoValidateMode = AutovalidateMode.disabled;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Uspješno"),
        content: const Text("Post je uspješno objavljen!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("U redu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dodaj"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(
            children: [
              Text(
                widget.post == null ? "Dodaj post" : "Uredi post",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildImage(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _naslovController,
                decoration: const InputDecoration(labelText: "Ime Posta"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return "Unesite naslov posta";
                  if (value.length > 100) return "Maksimalno 100 karaktera";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: subkategorijaId,
                decoration: const InputDecoration(labelText: "Subkategorija"),
                items: subOptions,
                onChanged: (val) => setState(() => subkategorijaId = val),
                validator: (val) =>
                    val == null ? "Odaberite subkategoriju" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sadrzajController,
                maxLines: 4,
                maxLength: 250,
                decoration: const InputDecoration(
                  labelText: "Opis",
                  counterText: "",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return "Unesite opis";
                  if (value.length > 250) return "Maksimalno 250 karaktera";
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text("${_sadrzajController.text.length} / 250"),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Premium postavka?"),
                      IgnorePointer(
                        ignoring: isObicanKorisnik,
                        child: Switch(
                          value: isObicanKorisnik ? false : premium,
                          onChanged: (val) => setState(() => premium = val),
                        ),
                      ),
                    ],
                  ),
                  if (isObicanKorisnik)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Samo premium korisnici mogu postaviti premium objavu.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF50C878),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Objavi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
