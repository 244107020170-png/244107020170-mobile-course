import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final itemNumber = index + 1;

          return ListTile(
            leading: CircleAvatar(
              child: Text('$itemNumber'),
            ),
            title: Text('Item $itemNumber'),
            subtitle: const Text('Tap to see the detail'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.go('/detail/$itemNumber');
            },
          );
        },
      ),
    );
  }
}