import 'package:flutter/material.dart';

import 'pages/helidx_page.dart';

void main() {
  runApp(const HeliDxApp());
}

class HeliDxApp extends StatelessWidget {
  const HeliDxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HeliDx',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF052F36),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF58E2B8),
          brightness: Brightness.dark,
        ),
      ),
      home: const HeliDxPage(),
    );
  }
}