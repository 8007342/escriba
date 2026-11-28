import 'package:flutter/material.dart';

import '../notepad/desk.dart';

/// Root widget: theme and the single desk screen.
class EscribaApp extends StatelessWidget {
  const EscribaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escriba',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3E6FB0)),
        useMaterial3: true,
      ),
      home: const Desk(),
    );
  }
}
