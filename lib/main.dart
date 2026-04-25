import 'package:flutter/material.dart';
import 'package:xfood/core/router/app_router.dart';
import 'package:xfood/core/theme/app_theme.dart';

void main() {
  runApp(const XfoodApp());
}

class XfoodApp extends StatelessWidget {
  const XfoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Xfood',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Hoặc ThemeMode.light
      routerConfig: appRouter,
    );
  }
}


