import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Notify'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await ref
                  .read(authStateProvider.notifier)
                  .logout();

              if (context.mounted) {
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(
            Icons.school,
            size: 80,
          ),

          const SizedBox(height: 24),

          const Text(
            'Campus Announcements',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Welcome to Campus Notify. '
            'Your authenticated session is active.',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.campaign,
              ),
              title: const Text(
                'New Campus Announcement',
              ),
              subtitle: const Text(
                'Tap to view announcement details.',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                context.go(
                  '/announcement/001',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}