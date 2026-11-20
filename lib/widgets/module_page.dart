import 'package:flutter/material.dart';

class ModulePage extends StatelessWidget {
  const ModulePage({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(title, style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(description, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
