import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/custom_button.dart';
import 'package:plantcare_desktop/common/widgets/custom_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void handleLogin() async {
    setState(() => isLoading = true);

    // Simulacija login poziva
    await Future.delayed(const Duration(seconds: 2));

    setState(() => isLoading = false);

    // TODO: Napravi pravu autentifikaciju ovdje
    print('Email: ${emailController.text}');
    print('Password: ${passwordController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Lijevi branding panel
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: const Center(
                child: Text(
                  'ZeleniKutak Admin',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
            ),
          ),

          // Desni login panel
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Dobrodošli!', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 24),
                  CustomInput(
                    label: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    label: 'Lozinka',
                    controller: passwordController,
                    obscureText: true,
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Prijava',
                    isLoading: isLoading,
                    onPressed: handleLogin,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
