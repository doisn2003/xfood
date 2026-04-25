import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/shared/models/order_model.dart';

class OrderDetailSheet extends StatelessWidget {
  final OrderModel order;

  const OrderDetailSheet({super.key, required this.order});

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return '${buffer}đ';
  }

  String _statusEmoji(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return '⏳';
      case OrderStatus.preparing:
        return '🍳';
      case OrderStatus.delivering:
        return '🚴';
      case OrderStatus.completed:
        return '✅';
      case OrderStatus.cancelled:
        return '❌';
    }
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Đang chờ xác nhận';
      case OrderStatus.preparing:
        return 'Nhà hàng đang chuẩn bị';
      case OrderStatus.delivering:
        return 'Shipper đang giao hàng';
      case OrderStatus.completed:
        return 'Đã giao thành công';
      case OrderStatus.cancelled:
        return 'Đã hủy';
    }
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Chi Tiết Đơn Hàng 📦',
                    style: AppTypography.h3.copyWith(color: AppColors.primary),
                  ),
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

          // Status progress
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  // Progress steps
                  Row(
                    children: [
                      _buildStep('Xác nhận', order.status.index >= 0, order.status == OrderStatus.pending),
                      _buildConnector(order.status.index >= 1),
                      _buildStep('Chuẩn bị', order.status.index >= 1, order.status == OrderStatus.preparing),
                      _buildConnector(order.status.index >= 2),
                      _buildStep('Giao hàng', order.status.index >= 2, order.status == OrderStatus.delivering),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_statusEmoji(order.status)} ${_statusLabel(order.status)}',
                    style: AppTypography.subtitle.copyWith(color: AppColors.tertiary),
                  ),
                ],
              ),
            ),
          ),

          // Delivery address
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.location_solid, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Giao đến', style: AppTypography.caption),
                        const SizedBox(height: 2),
                        Text(order.deliveryAddress, style: AppTypography.body, maxLines: 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Items
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Món đã đặt', style: AppTypography.caption),
                  const SizedBox(height: 12),
                  ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item.productImageUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 40, height: 40,
                              color: AppColors.surfaceContainerHigh,
                              child: const Icon(Icons.fastfood, size: 16, color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${item.productName} x${item.quantity}',
                            style: AppTypography.body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatPrice(item.subtotal),
                          style: AppTypography.body.copyWith(color: AppColors.tertiary),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),

          // Bill summary
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _billRow('Tạm tính', _formatPrice(order.subtotal)),
                  const SizedBox(height: 4),
                  _billRow('Phí giao', _formatPrice(order.shippingFee)),
                  if (order.discountAmount > 0) ...[
                    const SizedBox(height: 4),
                    _billRow('Giảm giá', '-${_formatPrice(order.discountAmount)}', valueColor: AppColors.tertiary),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: AppColors.surfaceContainerHighest),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng cộng', style: AppTypography.subtitle),
                      Text(
                        _formatPrice(order.totalAmount),
                        style: AppTypography.h3.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String label, bool isActive, bool isCurrent) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
              boxShadow: isCurrent
                  ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 12)]
                  : [],
            ),
            child: Center(
              child: Icon(
                isActive ? CupertinoIcons.checkmark : CupertinoIcons.circle,
                size: 14,
                color: isActive ? AppColors.textDark : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 10,
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(bool isActive) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _billRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.caption),
        Text(value, style: AppTypography.body.copyWith(color: valueColor)),
      ],
    );
  }
}
