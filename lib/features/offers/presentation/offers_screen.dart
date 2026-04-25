import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/offers/presentation/bloc/offers_cubit.dart';
import 'package:xfood/features/offers/presentation/widgets/lucky_wheel_widget.dart';
import 'package:xfood/features/offers/presentation/widgets/voucher_list_sheet.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

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
        child: BlocBuilder<OffersCubit, OffersState>(
          builder: (context, state) {
            if (state is OffersLoading || state is OffersInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is OffersError) {
              return Center(child: Text('Lỗi: ${state.message}', style: AppTypography.body));
            }
            if (state is OffersLoaded) {
              return CustomScrollView(
                slivers: [
                  // 1. Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Text(
                        'Ưu Đãi Khuya 🌙',
                        style: AppTypography.h1.copyWith(
                          color: AppColors.primary,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),

                  // 2. Two cards: Voucher + Roulette
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          // Voucher Card
                          Expanded(
                            child: _ActionCard(
                              title: 'Voucher',
                              subtitle: '${state.availableVoucherCount} mã',
                              emoji: '🎟️',
                              gradientColors: const [
                                Color(0xFFFF85FF),
                                Color(0xFFE972EA),
                              ],
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<OffersCubit>(),
                                    child: const VoucherListSheet(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Roulette Card
                          Expanded(
                            child: _ActionCard(
                              title: 'Vòng Quay',
                              subtitle: 'Thử Vận May',
                              emoji: '🎰',
                              gradientColors: const [
                                Color(0xFF8FF5FF),
                                Color(0xFF6BC5D2),
                              ],
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<OffersCubit>(),
                                    child: const LuckyWheelDialog(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Divider + Title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                      child: Text('Món Ngon Giá Hời 🔥', style: AppTypography.h3),
                    ),
                  ),

                  // 4. Product Grid (2 columns)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.62,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = state.products[index];
                          final shop = state.getShopForProduct(product);
                          final fakePrice = (product.price * 1.1).round();

                          return GestureDetector(
                            onTap: () {
                              context.push('/product_detail/${product.id}');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 1.1,
                                      child: Image.asset(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: AppColors.surfaceContainerLow,
                                          child: const Icon(
                                            Icons.fastfood,
                                            color: AppColors.textSecondary,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Info
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: AppTypography.subtitle.copyWith(fontSize: 13),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          if (shop != null)
                                            Text(
                                              shop.name,
                                              style: AppTypography.caption.copyWith(fontSize: 11),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          const Spacer(),
                                          // Price row: fake strikethrough + real price
                                          Row(
                                            children: [
                                              Text(
                                                _formatPrice(fakePrice),
                                                style: AppTypography.caption.copyWith(
                                                  decoration: TextDecoration.lineThrough,
                                                  decorationColor: AppColors.textSecondary,
                                                  color: AppColors.textSecondary,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                _formatPrice(product.price),
                                                style: AppTypography.subtitle.copyWith(
                                                  color: AppColors.tertiary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: state.products.length,
                      ),
                    ),
                  ),

                  // Bottom padding for nav bar
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
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

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background emoji
            Positioned(
              right: -10,
              bottom: -10,
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: 70,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTypography.subtitle.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textDark.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
