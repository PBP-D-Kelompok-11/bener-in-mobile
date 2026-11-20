import 'package:flutter/material.dart';

import '../data/benerin_api.dart';
import '../widgets/api_panel.dart';
import '../widgets/module_page.dart';

class ReviewImpactPage extends StatelessWidget {
  const ReviewImpactPage({super.key, required this.api, required this.account});

  final BenerinApi api;
  final ApiAccount? account;

  @override
  Widget build(BuildContext context) {
    final canView = account?.role == 'customer';

    return ModulePage(
      title: 'Review & Impact Tracker',
      description: canView
          ? 'Progres dihitung dari permintaan reparasi yang selesai.'
          : 'Masuk sebagai Customer lewat tab Akun untuk melihat impact.',
      children: [
        if (canView)
          ApiPanel<ApiJson>(
            load: api.impact,
            builder: (impact) {
              final badge = impact['current_badge'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${impact['saved_count']} reparasi berhasil'),
                  if (badge is ApiJson) Text('Badge · ${badge['name']}'),
                  Text('Progres badge · ${impact['progress_percent']}%'),
                ],
              );
            },
          ),
      ],
    );
  }
}
