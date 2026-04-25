import 'package:flutter/material.dart';
import 'package:xfood/core/theme/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home Screen (Đồ ăn đêm)', style: AppTypography.h2),
      ),
    );
  }
}
