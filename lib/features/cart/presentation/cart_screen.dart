import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/core/widgets/primary_button.dart';
import 'package:xfood/features/cart/presentation/bloc/cart_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng của bạn'),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.cart, size: 80, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text('Giỏ hàng đang trống', style: AppTypography.subtitle),
                  const SizedBox(height: 8),
                  Text('Hãy chọn vài món ăn đêm nhé!', style: AppTypography.bodySecondary),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // 1. Danh sách món ăn
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = state.items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(32), // xl radius
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                item.product.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 80,
                                  color: AppColors.surfaceContainerHighest,
                                  child: const Icon(Icons.fastfood, color: AppColors.textSecondary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: AppTypography.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text('${item.product.price}đ', style: AppTypography.body.copyWith(color: AppColors.tertiary)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => context.read<CartCubit>().removeProduct(item.product.id),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: AppColors.surfaceContainerHigh,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(CupertinoIcons.minus, size: 16),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text('${item.quantity}', style: AppTypography.subtitle),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () => context.read<CartCubit>().addProduct(item.product),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: AppColors.surfaceContainerHigh,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(CupertinoIcons.add, size: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: state.items.length,
                  ),
                ),
              ),

              // 2. Voucher & "Đi nhẹ nói khẽ"
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Voucher Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.ticket, color: AppColors.primary),
                                const SizedBox(width: 12),
                                Text('Chọn mã giảm giá', style: AppTypography.subtitle.copyWith(color: AppColors.primary)),
                              ],
                            ),
                            const Icon(CupertinoIcons.chevron_forward, color: AppColors.primary, size: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Đi nhẹ nói khẽ Toggle
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(CupertinoIcons.moon_stars_fill, color: AppColors.tertiary, size: 20),
                                    const SizedBox(width: 8),
                                    const Text('Đi nhẹ, nói khẽ', style: AppTypography.subtitle),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tài xế sẽ không gọi điện hay bấm chuông',
                                  style: AppTypography.caption,
                                ),
                              ],
                            ),
                            CupertinoSwitch(
                              value: state.quietDelivery,
                              activeColor: AppColors.tertiary,
                              onChanged: (value) {
                                context.read<CartCubit>().toggleQuietDelivery(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Bill Summary
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tạm tính', style: AppTypography.bodySecondary),
                          Text('${state.subtotal}đ', style: AppTypography.body),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Phí giao hàng', style: AppTypography.bodySecondary),
                          const Text('15000đ', style: AppTypography.body),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(color: AppColors.surfaceContainerHighest),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng cộng', style: AppTypography.h3),
                          Text('${state.total + 15000}đ', style: AppTypography.h2.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
      bottomSheet: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -10),
                )
              ],
            ),
            child: PrimaryButton(
              text: 'Đặt món ngay',
              icon: CupertinoIcons.rocket_fill,
              onPressed: () {
                // Checkout Logic -> Show success dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.surfaceContainerLow,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    title: const Center(child: Icon(CupertinoIcons.check_mark_circled_solid, color: AppColors.tertiary, size: 64)),
                    content: const Text(
                      'Đặt món thành công!\nCú đêm chuẩn bị nạp năng lượng nhé.',
                      textAlign: TextAlign.center,
                      style: AppTypography.subtitle,
                    ),
                    actions: [
                      PrimaryButton(
                        text: 'Về trang chủ',
                        onPressed: () {
                          Navigator.pop(context); // close dialog
                          // Need to clear cart? Left out for brevity
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
