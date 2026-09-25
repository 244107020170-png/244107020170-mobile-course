import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/settings_page.dart';
import 'pages/notes_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return darkMode.when(
      data: (isDarkMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Week 5 Offline Notes',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode:
              isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const NotesPage(),
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stackTrace) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}