import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/core/widgets/primary_button.dart';
import 'package:xfood/features/shop_dashboard/presentation/bloc/shop_cubit.dart';

class ShopProfileTab extends StatelessWidget {
  const ShopProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt Quán'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<ShopCubit, ShopState>(
          builder: (context, state) {
            if (state.status == ShopStatus.loading || state.shopInfo == null) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            final shop = state.shopInfo!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        shop.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 100, height: 100, color: Colors.grey,
                          child: const Icon(Icons.store, size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(child: Text(shop.name, style: AppTypography.h2)),
                  Center(child: Text(shop.address, style: AppTypography.caption)),
                  const SizedBox(height: 32),
                  
                  // Status Toggle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceContainerHighest),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(shop.isOpen ? 'Đang mở cửa' : 'Đã đóng cửa', style: AppTypography.h3),
                        Switch(
                          value: shop.isOpen,
                          activeColor: AppColors.success,
                          onChanged: (val) {
                            context.read<ShopCubit>().updateShopStatus(val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mock Features
                  _buildListTile(Icons.notifications, 'Cài đặt thông báo'),
                  _buildListTile(Icons.flash_on, 'Flash Sale Đêm Khuya'),
                  _buildListTile(Icons.campaign, 'Gửi tin nhắn hàng loạt'),

                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Chuyển về Người Mua',
                    icon: Icons.person_rounded,
                    onPressed: () {
                      // Navigate back to user profile (main app)
                      context.go('/profile');
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: AppTypography.body),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
      onTap: () {
        // Implement mock navigation if needed
      },
    );
  }
}
