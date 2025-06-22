import 'package:flutter/material.dart';
import 'package:plantcare_desktop/features/kategorije/kategorije_screen.dart';
import 'package:plantcare_desktop/features/katalog/katalog_screen.dart';
import 'package:plantcare_desktop/features/korisnici/korisnici_screen.dart';
import 'package:plantcare_desktop/features/notifikacije/notifikacije_screen.dart';
import 'package:plantcare_desktop/features/obavijesti/obavijesti_screen.dart';
import 'package:plantcare_desktop/features/post/post_screen.dart';
import 'package:plantcare_desktop/features/report/report_screen.dart';
import 'package:plantcare_desktop/features/subkategorije/subkategorije_screen.dart';
import 'package:plantcare_desktop/layout/main_layout.dart';
import 'package:plantcare_desktop/providers/auth_provider.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  String selectedSection = 'post'; // default prikaz

  Widget getSectionContent() {
    switch (selectedSection) {
      case 'korisnici':
        return const KorisniciScreen();
      case 'kategorije':
        return const KategorijeScreen();
      case 'subkategorije':
        return const SubkategorijeScreen();
      case 'katalog':
        return const KatalogScreen();
      case 'obavijesti':
        return const ObavijestiScreen();
      case 'notifikacije':
        return const NotifikacijeScreen();
      case 'izvjestaji':
        return const ReportScreen();
      case 'post':
      default:
        return const PostScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: selectedSection,
      onAddPressed: () {},
      onSearch: (query) {
        print('Search in $selectedSection: $query');
      },
      child: getSectionContent(),
      onSectionChange: (newSection) {
        if (newSection == 'logout') {
          AuthProvider.logout(context);
        } else {
          setState(() => selectedSection = newSection);
        }
      },
    );
  }
}
