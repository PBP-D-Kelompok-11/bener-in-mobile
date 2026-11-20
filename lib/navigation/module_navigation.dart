import 'package:flutter/material.dart';

import '../pages/account_page.dart';
import '../pages/discovery_page.dart';
import '../pages/partner_page.dart';
import '../pages/repair_requests_page.dart';
import '../pages/review_impact_page.dart';

enum _Module {
  account('Akun', Icons.person_outline, AccountPage()),
  repairs('Reparasi', Icons.assignment_outlined, RepairRequestsPage()),
  partner('Mitra', Icons.storefront_outlined, PartnerPage()),
  discovery('Jelajahi', Icons.map_outlined, DiscoveryPage()),
  impact('Impact', Icons.eco_outlined, ReviewImpactPage());

  const _Module(this.label, this.icon, this.page);

  final String label;
  final IconData icon;
  final Widget page;
}

class ModuleNavigation extends StatefulWidget {
  const ModuleNavigation({super.key});

  @override
  State<ModuleNavigation> createState() => _ModuleNavigationState();
}

class _ModuleNavigationState extends State<ModuleNavigation> {
  var _selectedModule = _Module.discovery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('bener.in')),
      body: _selectedModule.page,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedModule.index,
        onDestinationSelected: (index) {
          setState(() {
            _selectedModule = _Module.values[index];
          });
        },
        destinations: [
          for (final module in _Module.values)
            NavigationDestination(icon: Icon(module.icon), label: module.label),
        ],
      ),
    );
  }
}
