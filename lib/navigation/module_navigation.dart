import 'package:flutter/material.dart';

import '../data/benerin_api.dart';
import '../pages/account_page.dart';
import '../pages/discovery_page.dart';
import '../pages/partner_page.dart';
import '../pages/repair_requests_page.dart';
import '../pages/review_impact_page.dart';

enum _Module {
  account('Akun', Icons.person_outline),
  repairs('Reparasi', Icons.assignment_outlined),
  partner('Mitra', Icons.storefront_outlined),
  discovery('Jelajahi', Icons.map_outlined),
  impact('Impact', Icons.eco_outlined);

  const _Module(this.label, this.icon);

  final String label;
  final IconData icon;
}

class ModuleNavigation extends StatefulWidget {
  const ModuleNavigation({super.key, this.api});

  final BenerinApi? api;

  @override
  State<ModuleNavigation> createState() => _ModuleNavigationState();
}

class _ModuleNavigationState extends State<ModuleNavigation> {
  late final _api = widget.api ?? BenerinApi();
  var _selectedModule = _Module.discovery;
  ApiAccount? _account;
  int? _partnerId;

  @override
  void dispose() {
    if (widget.api == null) _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('bener.in')),
      body: switch (_selectedModule) {
        _Module.account => AccountPage(
          api: _api,
          account: _account,
          onAccountChanged: (account) {
            if (mounted) setState(() => _account = account);
          },
        ),
        _Module.repairs => RepairRequestsPage(
          api: _api,
          signedIn: _account != null,
        ),
        _Module.partner => PartnerPage(api: _api, partnerId: _partnerId),
        _Module.discovery => DiscoveryPage(
          api: _api,
          onPartnerSelected: (id) {
            setState(() {
              _partnerId = id;
              _selectedModule = _Module.partner;
            });
          },
        ),
        _Module.impact => ReviewImpactPage(api: _api, account: _account),
      },
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
