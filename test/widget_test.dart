import 'package:benerin/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens the bener.in welcome screen', (tester) async {
    await tester.pumpWidget(const BenerinApp());

    expect(find.text('bener.in'), findsOneWidget);
    expect(
      find.text('Temukan mitra reparasi dan pantau perbaikan barang.'),
      findsOneWidget,
    );
  });
}
