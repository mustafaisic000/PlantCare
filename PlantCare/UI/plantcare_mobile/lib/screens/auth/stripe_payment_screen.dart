import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/korisnici_provider.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/providers/uplata_provider.dart';
import 'package:plantcare_mobile/providers/util.dart'; // imageFromString
import 'package:plantcare_mobile/.env';

class StripePaymentScreen extends StatefulWidget {
  const StripePaymentScreen({super.key});

  @override
  State<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  final _uplataProvider = UplataProvider();
  final _korisnikProvider = KorisnikProvider();
  final _postProvider = PostProvider();
  bool _isLoading = false;
  List<Post> _premiumPosts = [];

  @override
  void initState() {
    super.initState();
    _startPaymentFlow();
  }

  Future<void> _startPaymentFlow() async {
    try {
      setState(() => _isLoading = true);

      final paymentIntent = await _createPaymentIntent('10', 'bam');
      if (!mounted) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'PlantCare',
          paymentMethodOrder: ['card'],
        ),
      );
      if (!mounted) return;

      await Stripe.instance.presentPaymentSheet();
      if (!mounted) return;

      final korisnikId = AuthProvider.korisnik?.korisnikId;
      if (korisnikId != null) {
        await _korisnikProvider.promoteToPremium(korisnikId);
        if (!mounted) return;

        final updatedKorisnik = await _korisnikProvider.getById(korisnikId);
        AuthProvider.korisnik = updatedKorisnik;
        if (!mounted) return;

        await _uplataProvider.insert({
          'korisnikId': korisnikId,
          'iznos': 10.0,
          'datum': DateTime.now().toIso8601String(),
        });
        if (!mounted) return;

        final data = await _postProvider.get(
          filter: {'Premium': true, 'Status': true},
        );
        _premiumPosts = data.result;

        if (!mounted) return;

        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Čestitamo!"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Postali ste premium korisnik! Sada imate pristup svim zaključanim objavama.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (_premiumPosts.isEmpty)
                    const Text("Nema dostupnih premium objava."),
                  if (_premiumPosts.isNotEmpty)
                    SizedBox(
                      height: 300, // ili 250, zavisi koliko želiš da se vidi
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.9,
                            ),
                        itemCount: _premiumPosts.length,
                        itemBuilder: (context, index) {
                          final post = _premiumPosts[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                  child: post.slika != null
                                      ? imageFromString(post.slika!)
                                      : Image.asset(
                                          "assets/images/no_image.jpg",
                                        ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  post.naslov,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Zatvori"),
              ),
            ],
          ),
        );
        if (!mounted) return;

        Navigator.pop(context, true);
      }
    } on StripeException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Plaćanje otkazano: ${e.error.localizedMessage}"),
        ),
      );
      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      print("❌ Neočekivana greška nakon plaćanja: $e");
      print(stackTrace);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Greška: ${e.toString()}")));
      Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(title: const Text("Plaćanje Premium Paketa")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text("Pokretanje plaćanja..."),
      ),
    );
  }
}
