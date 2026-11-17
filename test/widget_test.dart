import 'package:flutter_test/flutter_test.dart';
import 'package:gs_cross/main.dart';

void main() {
  testWidgets('Carrega a tela principal com abas', (tester) async {
    await tester.pumpWidget(const AplicativoCantareira());
    expect(find.text('Cantareira Watch'), findsOneWidget);
  });
}