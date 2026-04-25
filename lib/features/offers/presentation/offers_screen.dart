import 'package:flutter/material.dart';
import 'package:xfood/core/theme/app_typography.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Ưu Đãi & Vòng Quay', style: AppTypography.h2),
      ),
    );
  }
}
