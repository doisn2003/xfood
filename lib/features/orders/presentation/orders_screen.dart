import 'package:flutter/material.dart';
import 'package:xfood/core/theme/app_typography.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Đơn Hàng & Tracking', style: AppTypography.h2),
      ),
    );
  }
}
