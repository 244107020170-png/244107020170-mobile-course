import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/prefs.dart';

final prefsRepositoryProvider = Provider(
  (ref) => PrefsRepository(),
);

final darkModeProvider =
    AsyncNotifierProvider<DarkModeNotifier, bool>(
  DarkModeNotifier.new,
);

class DarkModeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() {
    return ref.watch(prefsRepositoryProvider).getDarkMode();
  }

  Future<void> toggle() async {
    final next = !(state.value ?? false);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref
          .read(prefsRepositoryProvider)
          .setDarkMode(next);

      return next;
    });
  }
}

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String? lastOpened;

  @override
  void initState() {
    super.initState();
    _loadLastOpened();
  }

  Future<void> _loadLastOpened() async {
    final repository = ref.read(prefsRepositoryProvider);

    final previousOpened = await repository.getLastOpened();

    await repository.markOpenedNow();

    if (!mounted) return;

    setState(() {
      lastOpened = previousOpened;
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: darkMode.when(
        data: (isDarkMode) {
          return Column(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text(
                  'Save dark mode preference locally',
                ),
                value: isDarkMode,
                onChanged: (_) {
                  ref
                      .read(darkModeProvider.notifier)
                      .toggle();
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Last opened'),
                subtitle: Text(
                  lastOpened ?? 'This is your first visit',
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
      ),
    );
  }
}