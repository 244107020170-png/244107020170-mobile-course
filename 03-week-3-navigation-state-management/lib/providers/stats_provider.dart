import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    return _fetchStats();
  }

  Future<List<String>> _fetchStats() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    final shouldFail = Random().nextDouble() < 0.3;

    if (shouldFail) {
      throw Exception(
        'Failed to connect to the server',
      );
    }

    return const [
      'Completed tasks: 8',
      'Pending tasks: 3',
      'Completion rate: 73%',
    ];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      _fetchStats,
    );
  }
}

final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<String>>(
  StatsNotifier.new,
);