import 'package:flutter/material.dart';

import '../data/benerin_api.dart';
import '../widgets/api_panel.dart';
import '../widgets/module_page.dart';

class PartnerPage extends StatelessWidget {
  const PartnerPage({super.key, required this.api, required this.partnerId});

  final BenerinApi api;
  final int? partnerId;

  @override
  Widget build(BuildContext context) {
    final id = partnerId;

    return ModulePage(
      title: 'Profil Mitra',
      description: id == null
          ? 'Pilih mitra dari tab Jelajahi untuk membuka profilnya.'
          : 'Layanan dan informasi usaha Mitra Reparasi.',
      children: [
        if (id != null)
          ApiPanel<ApiJson>(
            key: ValueKey(id),
            load: () => api.partner(id),
            builder: (partner) {
              final services = partner['layanan'];
              final phone = partner['phone'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${partner['name']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('${partner['address']}'),
                  if (services is List && services.isNotEmpty)
                    Text('Layanan · ${services.join(', ')}'),
                  if (phone is String && phone.isNotEmpty)
                    Text('Kontak · $phone'),
                ],
              );
            },
          ),
      ],
    );
  }
}
