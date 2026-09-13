import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail $id'),
      ),
      body: Center(
        child: Text(
          'You opened item with id: $id',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}