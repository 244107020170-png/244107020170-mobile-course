import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:week_3_navigation_state_management/providers/stats_provider.dart';

void main() {
  test(
    'stats provider eventually returns statistics',
    () async {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      final result = await container.read(
        statsProvider.future,
      );

      expect(result, isA<List<String>>());
      expect(result.length, 3);
    },
    timeout: const Timeout(
      Duration(seconds: 10),
    ),
  );
}