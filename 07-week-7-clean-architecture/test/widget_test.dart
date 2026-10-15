import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campus_notify/main.dart';

void main() {
  testWidgets('Campus Notify app loads', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CampusNotifyApp(),
      ),
    );

    // Allow the initial authentication check to complete.
    await tester.pump(const Duration(seconds: 1));

    expect(
      find.text('Campus Notify'),
      findsOneWidget,
    );
  });
}