import 'package:flutter/widgets.dart';

import '../widgets/module_page.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePage(
      title: 'Peta Reparasi',
      description:
          'Temukan mitra reparasi di sekitar dan simpan tempat pilihan.',
    );
  }
}
