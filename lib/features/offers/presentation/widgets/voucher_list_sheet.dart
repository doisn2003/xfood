import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:xfood/features/offers/presentation/bloc/offers_cubit.dart';
import 'package:xfood/features/shared/models/voucher_model.dart';

class VoucherListSheet extends StatelessWidget {
  const VoucherListSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  // Handle
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Voucher Của Bạn 🎟️',
                    style: AppTypography.h2.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),

                  // List
                  Expanded(
                    child: BlocBuilder<OffersCubit, OffersState>(
                      builder: (context, state) {
                        if (state is! OffersLoaded) {
                          return const Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          );
                        }

                        final vouchers = state.vouchers;
                        if (vouchers.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('🤷', style: TextStyle(fontSize: 64)),
                                SizedBox(height: 12),
                                Text('Chưa có voucher nào', style: AppTypography.subtitle),
                                Text('Quay vòng may mắn để nhận nhé!', style: AppTypography.bodySecondary),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                          itemCount: vouchers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final voucher = vouchers[index];
                            return _VoucherCard(voucher: voucher);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Close button
              Positioned(
                top: 12,
                right: 24,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.xmark_circle_fill, color: AppColors.textSecondary, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VoucherCard extends StatelessWidget {
  final VoucherModel voucher;
  const _VoucherCard({required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: voucher.isUsed ? 0.4 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: voucher.isUsed
                ? AppColors.textSecondary.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            // Left: Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: voucher.isFreeship
                    ? AppColors.tertiary.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  voucher.isFreeship
                      ? CupertinoIcons.car_detailed
                      : CupertinoIcons.ticket,
                  color: voucher.isFreeship ? AppColors.tertiary : AppColors.primary,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Middle: Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.code,
                    style: AppTypography.subtitle.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(voucher.description, style: AppTypography.caption),
                  if (voucher.isUsed) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Đã sử dụng',
                      style: AppTypography.caption.copyWith(color: AppColors.error),
                    ),
                  ],
                ],
              ),
            ),

            // Right: Button
            if (!voucher.isUsed)
              GestureDetector(
                onTap: () {
                  context.read<CartCubit>().applyVoucher(voucher);
                  context.read<OffersCubit>().useVoucher(voucher.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Đã áp dụng ${voucher.code} 🎉',
                        style: const TextStyle(color: AppColors.textDark),
                      ),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryContainer],
                    ),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text('Áp dụng', style: AppTypography.button.copyWith(fontSize: 12)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
