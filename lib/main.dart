import 'package:flutter/material.dart';

void main() {
  runApp(const BenerinApp());
}

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
      home: const _WelcomeScreen(),
    );
  }
}

class _WelcomeScreen extends StatelessWidget {
  const _WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.build_circle_outlined,
                    size: 72,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text('bener.in', style: theme.textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Text(
                    'Temukan mitra reparasi dan pantau perbaikan barang.',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
