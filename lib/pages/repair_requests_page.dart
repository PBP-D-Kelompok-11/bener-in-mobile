import 'package:flutter/material.dart';

import '../data/benerin_api.dart';
import '../widgets/api_panel.dart';
import '../widgets/module_page.dart';

class RepairRequestsPage extends StatelessWidget {
  const RepairRequestsPage({
    super.key,
    required this.api,
    required this.signedIn,
  });

  final BenerinApi api;
  final bool signedIn;

  @override
  Widget build(BuildContext context) {
    return ModulePage(
      title: 'Permintaan Reparasi',
      description: signedIn
          ? 'Lihat permintaan yang terkait dengan akunmu.'
          : 'Masuk lewat tab Akun untuk melihat permintaan reparasi.',
      children: [
        if (signedIn)
          ApiPanel<List<ApiJson>>(
            load: api.repairs,
            builder: (repairs) => repairs.isEmpty
                ? const Text('Belum ada permintaan reparasi.')
                : Column(
                    children: [
                      for (final repair in repairs)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('${repair['item_name']}'),
                          subtitle: Text(
                            '${repair['mitra_name']} · ${repair['status']}',
                          ),
                        ),
                    ],
                  ),
          ),
      ],
    );
  }
}
