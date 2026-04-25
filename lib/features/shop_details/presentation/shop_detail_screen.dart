import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:xfood/features/shop_details/presentation/bloc/shop_detail_cubit.dart';

class ShopDetailScreen extends StatefulWidget {
  final String shopId;
  const ShopDetailScreen({super.key, required this.shopId});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ShopDetailCubit>().loadShopDetails(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShopDetailCubit, ShopDetailState>(
        builder: (context, state) {
          if (state is ShopDetailLoading || state is ShopDetailInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (state is ShopDetailError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          if (state is ShopDetailLoaded) {
            final shop = state.shop;
            final products = state.products;

            return CustomScrollView(
              slivers: [
                // 1. Cover Image Header
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(CupertinoIcons.back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      shop.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 2. Shop Info & Group Order
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    transform: Matrix4.translationValues(0, -30, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(shop.name, style: AppTypography.h2),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: AppColors.secondary, size: 20),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${shop.rating} • ${shop.address}',
                                          style: AppTypography.bodySecondary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Nút Group Order phát sáng
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.2),
                                      blurRadius: 15,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(CupertinoIcons.person_3_fill, color: AppColors.primary),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Text('Thực Đơn (Kéo thả vào mồm)', style: AppTypography.h3),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Product List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                product.imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 100,
                                  height: 100,
                                  color: AppColors.surfaceContainerLow,
                                  child: const Icon(Icons.fastfood, color: AppColors.textSecondary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, style: AppTypography.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.description,
                                    style: AppTypography.caption,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${product.price}đ',
                                        style: AppTypography.subtitle.copyWith(color: AppColors.tertiary),
                                      ),
                                      // Nút [+] thêm vào giỏ hàng
                                      GestureDetector(
                                        onTap: () {
                                          context.read<CartCubit>().addProduct(product);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Đã thêm ${product.name} vào giỏ', style: const TextStyle(color: AppColors.textDark)),
                                              backgroundColor: AppColors.primary,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                                              duration: const Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primary.withValues(alpha: 0.3),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              )
                                            ],
                                          ),
                                          child: const Icon(CupertinoIcons.add, color: AppColors.textDark, size: 20),
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
                    childCount: products.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          }
          return const SizedBox();
        },
      ),
      // Giỏ hàng mini nổi lên khi có item
      floatingActionButton: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) return const SizedBox.shrink();
          
          return FloatingActionButton.extended(
            onPressed: () {
              // Trong thiết kế tab, bấm vào có thể đẩy sang Tab Giỏ Hàng hoặc mở Sheet
              // Tạm thời mở bottom sheet giỏ hàng nhanh
              context.go('/cart'); // Thay đổi tab nếu dùng StatefulShellRoute thì hơi khó từ đây, ta có thể route push hoặc pop.
            },
            backgroundColor: AppColors.primaryContainer,
            icon: const Icon(CupertinoIcons.cart_fill, color: AppColors.textDark),
            label: Text(
              '${state.items.length} món • ${state.total}đ',
              style: AppTypography.button.copyWith(color: AppColors.textDark),
            ),
          );
        },
      ),
    );
  }
}
