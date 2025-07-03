import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/korisnici_provider.dart';
import 'package:plantcare_mobile/providers/uplata_provider.dart';
import 'package:plantcare_mobile/.env';

class StripePaymentWidget extends StatefulWidget {
  final VoidCallback onSuccess;

  const StripePaymentWidget({super.key, required this.onSuccess});

  @override
  State<StripePaymentWidget> createState() => _StripePaymentWidgetState();
}

class _StripePaymentWidgetState extends State<StripePaymentWidget> {
  final _uplataProvider = UplataProvider();
  final _korisnikProvider = KorisnikProvider();
  bool _isLoading = false;

  Future<void> makePayment() async {
    try {
      setState(() => _isLoading = true);

      final paymentIntent = await _createPaymentIntent('10', 'bam');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'PlantCare',
          paymentMethodOrder: ['card'],
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final korisnikId = AuthProvider.korisnik?.korisnikId;
      if (korisnikId != null) {
        final updatedKorisnik = await _korisnikProvider.promoteToPremium(
          korisnikId,
        );

        await _uplataProvider.insert({
          'korisnikId': korisnikId,
          'iznos': 10.0,
          'datumUplate': DateTime.now().toIso8601String(),
        });

        AuthProvider.korisnik = updatedKorisnik;

        if (!mounted) return;

        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Uspješno ste nadograđeni!"),
            content: const Text(
              "Sada ste premium korisnik i imate pristup svim premium objavama.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("U redu"),
              ),
            ],
          ),
        );

        widget.onSuccess();
        Navigator.of(context).pop();
      }
    } on StripeException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Plaćanje otkazano: ${e.error.localizedMessage}"),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Greška prilikom plaćanja.")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
    String amount,
    String currency,
  ) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer $stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'amount': (int.parse(amount) * 100).toString(),
        'currency': currency,
        'automatic_payment_methods[enabled]': 'true',
        'setup_future_usage': 'off_session',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Stripe greška: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Postanite Premium"),
      content: const Text("Uplatom 10 KM dobijate pristup premium sadržaju."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Zatvori"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : makePayment,
          child: _isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Uplati"),
        ),
      ],
    );
  }
}
