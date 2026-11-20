import 'package:flutter/widgets.dart';

import '../widgets/module_page.dart';

class ReviewImpactPage extends StatelessWidget {
  const ReviewImpactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePage(
      title: 'Review & Impact Tracker',
      description: 'Beri ulasan dan lihat jumlah reparasi yang berhasil.',
    );
  }
}
