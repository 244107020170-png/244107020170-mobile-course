import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:responsive_dashboard/main.dart';

void main() {
  testWidgets(
    'Dashboard shows one column on a narrow screen',
    (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.reset);

      await tester.pumpWidget(const DashboardApp());

      expect(find.text('Assignments'), findsOneWidget);
      expect(find.text('Attendance'), findsOneWidget);
      expect(find.text('Portfolio'), findsOneWidget);
      expect(find.text('Current Week'), findsOneWidget);

      expect(
        find.byType(InfoCard),
        findsNWidgets(4),
      );
    },
  );

  testWidgets(
    'Dashboard shows two columns on a wide screen',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.reset);

      await tester.pumpWidget(const DashboardApp());

      expect(
        find.byType(InfoCard),
        findsNWidgets(4),
      );
    },
  );

  testWidgets(
    'Dark mode switch changes the theme',
    (tester) async {
      await tester.pumpWidget(const DashboardApp());

      expect(
        find.byType(CupertinoSwitch),
        findsOneWidget,
      );

      final switchFinder = find.byType(CupertinoSwitch);

      final switchWidget =
          tester.widget<CupertinoSwitch>(switchFinder);

      expect(switchWidget.value, false);

      await tester.tap(switchFinder);
      await tester.pump();

      final updatedSwitch =
          tester.widget<CupertinoSwitch>(switchFinder);

      expect(updatedSwitch.value, true);
    },
  );
}