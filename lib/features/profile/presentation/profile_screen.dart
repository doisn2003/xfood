import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/core/widgets/primary_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/mock/user_avatar.png'),
            ),
            const SizedBox(height: 16),
            const Text('Tôi (Cú Đêm)', style: AppTypography.h2),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Chuyển sang giao diện Chủ Quán',
              icon: Icons.storefront_rounded,
              onPressed: () {
                context.go('/shop_dashboard');
              },
            ),
          ],
        ),
      ),
    );
  }
}
