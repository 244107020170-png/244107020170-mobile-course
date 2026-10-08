import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'messaging/push_service.dart';
import 'pages/announcement_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await initLocalNotifications();
  await requestNotificationPermission();

  runApp(
    const ProviderScope(
      child: CampusNotifyApp(),
    ),
  );
}

class CampusNotifyApp extends ConsumerWidget {
  const CampusNotifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final router = GoRouter(
      redirect: (context, state) {
        final loggedIn = authState.value ?? false;
        final goingLogin =
            state.matchedLocation == '/login';

        if (!loggedIn && !goingLogin) {
          return '/login';
        }

        if (loggedIn && goingLogin) {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/announcement/:id',
          builder: (_, state) {
            return AnnouncementPage(
              id: state.pathParameters['id'] ?? '',
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Campus Notify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}