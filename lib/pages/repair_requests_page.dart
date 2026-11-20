import 'package:flutter/widgets.dart';

import '../widgets/module_page.dart';

class RepairRequestsPage extends StatelessWidget {
  const RepairRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePage(
      title: 'Permintaan Reparasi',
      description: 'Ajukan dan pantau perbaikan yang ditangani Mitra Reparasi.',
    );
  }
}
