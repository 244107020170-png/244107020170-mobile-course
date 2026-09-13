import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week_3_navigation_state_management/main.dart';
import 'package:week_3_navigation_state_management/widgets/todo_tile.dart';

void main() {
  testWidgets('adds a new task', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    expect(
      find.text('No tasks yet'),
      findsOneWidget,
    );

    await tester.tap(
      find.byIcon(Icons.add),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      'Do week 3 homework',
    );

    await tester.tap(
      find.text('Add'),
    );

    await tester.pumpAndSettle();

    expect(
      find.byType(TodoTile),
      findsOneWidget,
    );

    expect(
      find.text('Do week 3 homework'),
      findsOneWidget,
    );
  });
}