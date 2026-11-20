import 'package:benerin/app.dart';
import 'package:benerin/data/benerin_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens all five modules through the navigation bar', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(BenerinApp(api: _FixtureApi()));
    await tester.pumpAndSettle();

    expect(find.text('bener.in'), findsOneWidget);
    expect(find.text('Peta Reparasi'), findsOneWidget);

    const destinations = {
      'Akun': 'Autentikasi & Profil',
      'Reparasi': 'Permintaan Reparasi',
      'Mitra': 'Profil Mitra',
      'Impact': 'Review & Impact Tracker',
      'Jelajahi': 'Peta Reparasi',
    };
    for (final destination in destinations.entries) {
      await tester.tap(find.text(destination.key));
      await tester.pumpAndSettle();

      expect(find.text(destination.value), findsOneWidget);
    }
  });

  testWidgets('opens a partner and reads account modules after sign-in', (
    tester,
  ) async {
    await tester.pumpWidget(BenerinApp(api: _FixtureApi()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bengkel Uji'));
    await tester.pumpAndSettle();
    expect(find.text('Profil Mitra'), findsOneWidget);
    expect(find.text('Layanan · gadget'), findsOneWidget);

    await tester.tap(find.text('Akun'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'customer-uji');
    await tester.enterText(find.byType(TextFormField).at(1), 'sandi-uji');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Customer Uji · Customer'), findsOneWidget);

    await tester.tap(find.text('Reparasi'));
    await tester.pumpAndSettle();
    expect(find.text('Ponsel Uji'), findsOneWidget);

    await tester.tap(find.text('Impact'));
    await tester.pumpAndSettle();
    expect(find.text('1 reparasi berhasil'), findsOneWidget);

    await tester.tap(find.text('Akun'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Keluar'));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}

class _FixtureApi extends BenerinApi {
  static const ApiJson _partner = {
    'id': 1,
    'name': 'Bengkel Uji',
    'address': 'Depok',
    'layanan': ['gadget'],
    'distance_km': 0,
  };

  @override
  Future<ApiAccount> login(String username, String password) async {
    expect(username, 'customer-uji');
    expect(password, 'sandi-uji');
    return const ApiAccount(name: 'Customer Uji', role: 'customer');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<List<ApiJson>> nearby() async => [_partner];

  @override
  Future<ApiJson> partner(int id) async {
    expect(id, 1);
    return _partner;
  }

  @override
  Future<List<ApiJson>> repairs() async => [
    {
      'item_name': 'Ponsel Uji',
      'mitra_name': 'Bengkel Uji',
      'status': 'completed',
    },
  ];

  @override
  Future<ApiJson> impact() async => {
    'saved_count': 1,
    'current_badge': {'name': 'Mulai Bener'},
    'progress_percent': 20,
  };
}
