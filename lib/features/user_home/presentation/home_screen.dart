import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/user_home/presentation/bloc/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is HomeError) {
              return Center(child: Text('Lỗi: ${state.message}', style: AppTypography.body));
            }
            if (state is HomeLoaded) {
              return CustomScrollView(
                slivers: [
                  // 1. Header & Progress Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đói chưa Cú Đêm?',
                                    style: AppTypography.h1.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: AssetImage(state.user.avatarUrl),
                                backgroundColor: AppColors.surfaceContainerHigh,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Thử thách cú đêm - Neon Progress Bar
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Thử thách Cú Đêm', style: AppTypography.subtitle),
                                    Text('Cấp 2', style: AppTypography.subtitle.copyWith(color: AppColors.tertiary)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    value: 0.7,
                                    minHeight: 12,
                                    backgroundColor: AppColors.surfaceContainerHighest,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Còn 3 đơn nữa để nhận Voucher 50%!',
                                  style: AppTypography.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Banner Slider Placeholder
                  SliverToBoxAdapter(
                    child: Container(
                      height: 160,
                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryContainer],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Icon(
                              Icons.local_fire_department,
                              size: 150,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Midnight\nRoulette',
                                  style: AppTypography.h2.copyWith(color: AppColors.textDark, height: 1.1),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.textDark,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'Quay Ngay',
                                    style: AppTypography.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Categories Horizontal Scroll
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Text('Đang thèm gì?', style: AppTypography.h3),
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.categories.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final cat = state.categories[index];
                              // Chỉ highlight cái đầu tiên cho giống UI design
                              final isSelected = index == 0;
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.tertiary : AppColors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: isSelected ? [
                                    BoxShadow(
                                      color: AppColors.tertiary.withValues(alpha: 0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 4),
                                    )
                                  ] : [],
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Text(
                                      cat.iconUrl,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      cat.name,
                                      style: AppTypography.body.copyWith(
                                        color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 4. Popular Shops (Late Night Heroes)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    sliver: SliverToBoxAdapter(
                      child: Text('Late Night Heroes', style: AppTypography.h2),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final shop = state.popularShops[index];
                          return GestureDetector(
                            onTap: () {
                              context.go('/home/shop_details/${shop.id}');
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(40), // xl radius
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Hình ảnh quán
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.asset(
                                      shop.imageUrl,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(shop.name, style: AppTypography.h3),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.star_rounded, color: AppColors.secondary, size: 18),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${shop.rating} • 25-35 phút',
                                                  style: AppTypography.bodySecondary,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceContainerHighest,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: state.popularShops.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom padding for nav bar
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
