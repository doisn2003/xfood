import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:xfood/features/product_detail/presentation/bloc/product_detail_cubit.dart';
import 'package:xfood/features/shared/repositories/product_repository.dart';
import 'package:xfood/features/shared/repositories/shop_repository.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailCubit(
        productRepository: context.read<ProductRepository>(),
        shopRepository: context.read<ShopRepository>(),
      )..loadProduct(productId),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return '${buffer}đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading || state is ProductDetailInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is ProductDetailError) {
              return Center(child: Text('Lỗi: ${state.message}', style: AppTypography.body));
            }
            if (state is ProductDetailLoaded) {
              final product = state.product;
              final shop = state.shop;

              return Stack(
                children: [
                  // Main content
                  CustomScrollView(
                    slivers: [
                      // 1. Hero Image
                      SliverAppBar(
                        expandedHeight: 320,
                        pinned: true,
                        backgroundColor: AppColors.backgroundDark,
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
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.surfaceContainerHigh,
                                  child: const Icon(Icons.fastfood, color: AppColors.textSecondary, size: 80),
                                ),
                              ),
                              // Bottom gradient fade
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.backgroundDark.withValues(alpha: 0.9),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 2. Product Info
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name
                              Text(product.name, style: AppTypography.h2),
                              const SizedBox(height: 16),

                              // Shop info row
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        shop.imageUrl,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 48,
                                          height: 48,
                                          color: AppColors.surfaceContainerLow,
                                          child: const Icon(Icons.store, color: AppColors.textSecondary),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(shop.name, style: AppTypography.subtitle),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.star_rounded, color: AppColors.secondary, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${shop.rating} • ${shop.address}',
                                                style: AppTypography.caption,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Description
                              Text('Mô tả', style: AppTypography.h3),
                              const SizedBox(height: 8),
                              Text(product.description, style: AppTypography.body),
                              const SizedBox(height: 32),

                              // Price
                              Text('Giá', style: AppTypography.h3),
                              const SizedBox(height: 8),
                              Text(
                                _formatPrice(product.price),
                                style: AppTypography.h2.copyWith(color: AppColors.tertiary),
                              ),
                              const SizedBox(height: 32),

                              // Quantity selector
                              Text('Số lượng', style: AppTypography.h3),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _QuantityButton(
                                      icon: CupertinoIcons.minus,
                                      onTap: () => context.read<ProductDetailCubit>().decrementQuantity(),
                                      enabled: state.quantity > 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      child: Text(
                                        '${state.quantity}',
                                        style: AppTypography.h3.copyWith(color: AppColors.primary),
                                      ),
                                    ),
                                    _QuantityButton(
                                      icon: CupertinoIcons.add,
                                      onTap: () => context.read<ProductDetailCubit>().incrementQuantity(),
                                      enabled: true,
                                    ),
                                  ],
                                ),
                              ),

                              // Bottom padding for the floating button
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Floating Add to Cart button
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.backgroundDark.withValues(alpha: 0.0),
                            AppColors.backgroundDark,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          for (int i = 0; i < state.quantity; i++) {
                            context.read<CartCubit>().addProduct(product);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Đã thêm ${state.quantity}x ${product.name} vào giỏ 🛒',
                                style: const TextStyle(color: AppColors.textDark),
                              ),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          context.pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryContainer],
                            ),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                        ),
                          child: Center(
                            child: Text(
                              'Thêm vào giỏ • ${_formatPrice(state.totalPrice)}',
                              style: AppTypography.button.copyWith(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : AppColors.surfaceContainerLow,
          shape: BoxShape.circle,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.textDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}
