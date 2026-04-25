import 'package:flutter/material.dart';
import 'package:xfood/core/theme/app_theme.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/core/widgets/cute_text_field.dart';
import 'package:xfood/core/widgets/primary_button.dart';

void main() {
  runApp(const XfoodApp());
}

class XfoodApp extends StatelessWidget {
  const XfoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xfood',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Hoặc ThemeMode.light
      home: const TestDesignSystemScreen(),
    );
  }
}

class TestDesignSystemScreen extends StatelessWidget {
  const TestDesignSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xfood Design System'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Typography', style: AppTypography.h2),
            const SizedBox(height: 16),
            const Text('H1 - Mì Cay Hải Sản', style: AppTypography.h1),
            const Text('H2 - Trà Sữa Cú Đêm', style: AppTypography.h2),
            const Text('H3 - Giao Hàng Tự Túc', style: AppTypography.h3),
            const Text('Subtitle - Ghi chú cho quán', style: AppTypography.subtitle),
            const Text('Body - Giao hàng nhanh nhé', style: AppTypography.body),
            const Text('Caption - 15 mins', style: AppTypography.caption),
            const SizedBox(height: 32),
            const Text('Buttons', style: AppTypography.h2),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Đặt Đơn Ngay',
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Đang Xử Lý...',
              isLoading: true,
              onPressed: () {},
            ),
            const SizedBox(height: 32),
            const Text('Text Fields', style: AppTypography.h2),
            const SizedBox(height: 16),
            const CuteTextField(
              hintText: 'Nhập số điện thoại của bạn...',
              prefixIcon: Icons.phone_android_rounded,
            ),
            const SizedBox(height: 16),
            const CuteTextField(
              hintText: 'Nhập mã Voucher...',
              prefixIcon: Icons.local_activity_rounded,
            ),
            const SizedBox(height: 32),
            const Text('Mock Image Test', style: AppTypography.h2),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/mock/shop_1.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
