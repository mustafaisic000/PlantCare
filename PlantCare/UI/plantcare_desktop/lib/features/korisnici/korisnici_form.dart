import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/generic_form.dart';
import 'package:plantcare_desktop/models/korisnici_model.dart';
import 'package:plantcare_desktop/common/config/form_config.dart'
    as form_config;
import 'package:plantcare_desktop/providers/util.dart';

class KorisnikForm extends StatelessWidget {
  final Korisnik korisnik;
  final bool readOnly;

  const KorisnikForm({super.key, required this.korisnik, this.readOnly = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Naslov + X
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${korisnik.ime} ${korisnik.prezime}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ✅ Slika + Forma
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 240,
                    height: 240,
                    color: Colors.grey[300],
                    child: korisnik.slika != null && korisnik.slika!.isNotEmpty
                        ? imageFromString(korisnik.slika!)
                        : Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: GenericForm(
                    formKey: GlobalKey<FormState>(),
                    initialData: korisnik.toJson(),
                    config: form_config.getFormConfig(
                      'korisnik',
                      readOnly: readOnly,
                    ),
                    readOnly: readOnly,
                    onSubmit: (data) {
                      if (!readOnly) {
                        print("Podaci sačuvani: $data");
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
