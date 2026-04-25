import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/core/widgets/primary_button.dart';

class ShopDashboardScreen extends StatelessWidget {
  const ShopDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Giao diện Chủ Quán', style: AppTypography.h2),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Quay lại giao diện Người mua',
              icon: Icons.person_rounded,
              onPressed: () {
                context.go('/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
