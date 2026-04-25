import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/data_sources/mock_server/mock_database.dart';
import 'package:xfood/features/shared/models/voucher_model.dart';

class VoucherPickerSheet extends StatelessWidget {
  final int currentSubtotal;
  final VoucherModel? currentVoucher;
  final ValueChanged<VoucherModel?> onSelected;

  const VoucherPickerSheet({
    super.key,
    required this.currentSubtotal,
    this.currentVoucher,
    required this.onSelected,
  });

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
    final vouchers = MockDatabase.instance.vouchers.where((v) => !v.isUsed).toList();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chọn Voucher 🎟️',
                  style: AppTypography.h3.copyWith(color: AppColors.primary),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.xmark, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          // Remove voucher button (if one is selected)
          if (currentVoucher != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  onSelected(null);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.3)),
                  ),
                  child: const Center(
                    child: Text('Bỏ chọn voucher', style: AppTypography.subtitle),
                  ),
                ),
              ),
            ),

          // Voucher list
          if (vouchers.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Text('😴', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('Chưa có voucher nào', style: AppTypography.bodySecondary),
                ],
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                itemCount: vouchers.length,
                itemBuilder: (context, index) {
                  final v = vouchers[index];
                  final isEligible = v.minOrderAmount <= currentSubtotal;
                  final isSelected = currentVoucher?.id == v.id;

                  return GestureDetector(
                    onTap: isEligible
                        ? () {
                            onSelected(v);
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : isEligible
                                  ? AppColors.surfaceContainerHighest
                                  : Colors.transparent,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Opacity(
                        opacity: isEligible ? 1.0 : 0.4,
                        child: Row(
                          children: [
                            // Voucher icon
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: v.isFreeship
                                    ? AppColors.tertiary.withValues(alpha: 0.15)
                                    : AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Icon(
                                  v.isFreeship
                                      ? CupertinoIcons.car_detailed
                                      : CupertinoIcons.ticket,
                                  color: v.isFreeship ? AppColors.tertiary : AppColors.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    v.code,
                                    style: AppTypography.subtitle.copyWith(
                                      color: isSelected ? AppColors.primary : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(v.description, style: AppTypography.caption),
                                  if (!isEligible) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Đơn tối thiểu ${_formatPrice(v.minOrderAmount)}',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.error,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Discount amount
                            Text(
                              '-${_formatPrice(v.discountAmount)}',
                              style: AppTypography.subtitle.copyWith(
                                color: AppColors.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
