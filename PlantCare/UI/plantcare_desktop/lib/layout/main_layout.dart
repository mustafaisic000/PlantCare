import 'package:flutter/material.dart';
import 'package:plantcare_desktop/layout/sidebar.dart';
import 'package:plantcare_desktop/providers/auth_provider.dart';
import 'package:plantcare_desktop/providers/util.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onAddPressed;
  final ValueChanged<String>? onSearch;
  final ValueChanged<String>? onSectionChange;

  const MainLayout({
    required this.title,
    required this.child,
    this.onAddPressed,
    this.onSearch,
    this.onSectionChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selected: title.toLowerCase(),
            onItemSelected: onSectionChange!,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _capitalize(title),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          Text(
                            'Dobrodošli, ${AuthProvider.korisnik?.ime ?? ''}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 16),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[200],
                            child: ClipOval(
                              child:
                                  AuthProvider.korisnik?.slika != null &&
                                      AuthProvider.korisnik!.slika!.isNotEmpty
                                  ? SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: imageFromString(
                                        AuthProvider.korisnik!.slika!,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/images/placeholder.png',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
