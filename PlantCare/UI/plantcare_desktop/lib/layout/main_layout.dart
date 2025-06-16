import 'package:flutter/material.dart';
import 'package:plantcare_desktop/layout/sidebar.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const MainLayout({required this.title, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(
            selected: 'biljke', // privremeno statički — kasnije dinamički
            onItemSelected: (route) {
              // ovdje ne možemo koristiti setState jer je StatelessWidget
              // pravićemo wrapper za to
            },
          ),
          // Glavni sadržaj
          Expanded(
            child: Column(
              children: [
                // Topbar
                Container(
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        width: 240,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Pretraga...',
                            prefixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
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
}
