import 'package:fl_retrogame/routes/app_routes.dart';
import 'package:fl_retrogame/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RetroGame',
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      theme: AppTheme.gamerTheme,
    );
  }
}