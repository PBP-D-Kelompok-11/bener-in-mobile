import 'package:benerin/app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens all five modules through the navigation bar', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const BenerinApp());

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
}
