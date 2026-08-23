import 'package:checkin_flutter/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App widget tree builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CheckinApp()),
    );

    // Just verify it builds without throwing - don't pumpAndSettle
    // since platform channels (secure storage) aren't available in unit tests
    expect(tester.takeException(), isNull);
  });
}
