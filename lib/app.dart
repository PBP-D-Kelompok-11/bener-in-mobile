import 'package:flutter/material.dart';

import 'navigation/module_navigation.dart';

class BenerinApp extends StatelessWidget {
  const BenerinApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2F7D4F),
    );

    return MaterialApp(
      title: 'bener.in',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: colorScheme),
      home: const ModuleNavigation(),
    );
  }
}
