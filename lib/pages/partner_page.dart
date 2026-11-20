import 'package:flutter/widgets.dart';

import '../widgets/module_page.dart';

class PartnerPage extends StatelessWidget {
  const PartnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePage(
      title: 'Profil Mitra',
      description: 'Lihat layanan, lokasi, dan kontak Mitra Reparasi.',
    );
  }
}
