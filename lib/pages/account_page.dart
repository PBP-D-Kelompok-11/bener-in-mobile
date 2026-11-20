import 'package:flutter/widgets.dart';

import '../widgets/module_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePage(
      title: 'Autentikasi & Profil',
      description: 'Kelola akun dan profil Customer atau Mitra Reparasi.',
    );
  }
}
