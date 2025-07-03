import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/custom_input.dart';
import 'package:plantcare_desktop/common/widgets/custom_button.dart';
import 'package:plantcare_desktop/features/workspace/workspace_screen.dart';
import 'package:plantcare_desktop/providers/auth_provider.dart';
import 'package:plantcare_desktop/providers/korisnici_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void handleLogin() async {
    setState(() => isLoading = true);

    try {
      AuthProvider.username = usernameController.text;
      AuthProvider.password = passwordController.text;

      final korisnikProvider = KorisnikProvider();
      final korisnik = await korisnikProvider.authenticate();
      if (!mounted) return;
      if (korisnik.ulogaId != 1) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Pristup odbijen"),
            content: const Text(
              "Samo administrator ima pristup ovoj aplikaciji.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return;
      }

      AuthProvider.login(
        usernameController.text,
        passwordController.text,
        korisnik,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WorkspaceScreen()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Greška"),
          content: const Text("Pogrešno korisničko ime ili lozinka."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF50C878), Color(0xFF3AA866)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 800,
            height: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/plantIcon.png',
                      fit: BoxFit.cover,
                      height: double.infinity,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Dobrodošli nazad u Zeleni Kutak!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomInput(
                          label: 'Username',
                          controller: usernameController,
                          icon: Icons.person,
                          maxLength: 70,
                        ),
                        const SizedBox(height: 16),
                        CustomInput(
                          label: 'Password',
                          controller: passwordController,
                          icon: Icons.lock,
                          obscureText: true,
                          maxLength: 70,
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Sign in',
                          onPressed: handleLogin,
                          isLoading: isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
