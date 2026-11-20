import 'package:flutter/material.dart';

import '../data/benerin_api.dart';
import '../widgets/api_panel.dart';
import '../widgets/module_page.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({
    super.key,
    required this.api,
    required this.onPartnerSelected,
  });

  final BenerinApi api;
  final ValueChanged<int> onPartnerSelected;

  @override
  Widget build(BuildContext context) {
    return ModulePage(
      title: 'Peta Reparasi',
      description: 'Daftar mitra terdaftar dalam radius 10 km dari Depok.',
      children: [
        ApiPanel<List<ApiJson>>(
          load: api.nearby,
          builder: (partners) => partners.isEmpty
              ? const Text('Belum ada mitra yang ditemukan di area ini.')
              : Column(
                  children: [
                    for (final partner in partners)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('${partner['name']}'),
                        subtitle: Text(
                          '${partner['address']} · ${partner['distance_km']} km',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => onPartnerSelected(partner['id'] as int),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
