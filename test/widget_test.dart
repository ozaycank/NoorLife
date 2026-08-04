import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/app.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: NoorLifeApp()));

    expect(find.byType(NoorLifeApp), findsOneWidget);
  });
}
