import 'package:flutter_test/flutter_test.dart';
import 'package:gameflag/main.dart';

void main() {
  testWidgets('Teste de inicialização do Flag Game', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlagGameApp());
    expect(find.text('Flag Game'), findsOneWidget);
  });
}
