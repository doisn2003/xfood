import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/shared/models/order_model.dart';
import 'package:xfood/features/shop_dashboard/presentation/bloc/shop_cubit.dart';
import 'package:xfood/core/utils/currency_formatter.dart';

class ShopHomeTab extends StatelessWidget {
  const ShopHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng hôm nay'),
        centerTitle: true,
      ),
      body: BlocBuilder<ShopCubit, ShopState>(
        builder: (context, state) {
          if (state.status == ShopStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state.status == ShopStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Có lỗi xảy ra', style: AppTypography.body));
          }

          final orders = state.orders;
          if (orders.isEmpty) {
            return const Center(
              child: Text('Chưa có đơn hàng nào', style: AppTypography.body),
            );
          }

          // Sort orders by createdAt descending
          final sortedOrders = List<OrderModel>.from(orders)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sortedOrders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _OrderCard(order: sortedOrders[index]);
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (order.status) {
      case OrderStatus.pending:
        statusColor = AppColors.warning;
        statusText = 'Chờ xác nhận';
        break;
      case OrderStatus.preparing:
        statusColor = AppColors.primary;
        statusText = 'Đang chuẩn bị';
        break;
      case OrderStatus.delivering:
        statusColor = Colors.blue;
        statusText = 'Đang giao';
        break;
      case OrderStatus.completed:
        statusColor = AppColors.success;
        statusText = 'Hoàn thành';
        break;
      case OrderStatus.cancelled:
        statusColor = AppColors.error;
        statusText = 'Đã hủy';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#${order.id.substring(0, 5)}', style: AppTypography.h3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: AppTypography.caption.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Time
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                '${order.createdAt.hour.toString().padLeft(2, '0')}:${order.createdAt.minute.toString().padLeft(2, '0')} - ${order.createdAt.day.toString().padLeft(2, '0')}/${order.createdAt.month.toString().padLeft(2, '0')}/${order.createdAt.year}',
                style: AppTypography.caption,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.deliveryAddress,
                  style: AppTypography.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Items List
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.productImageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 48,
                          height: 48,
                          color: AppColors.surfaceContainerHighest,
                          child: const Icon(Icons.fastfood, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.productName, style: AppTypography.body.copyWith(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                            '${item.quantity} x ${CurrencyFormatter.format(item.price)}',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(item.subtotal),
                      style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          const Divider(color: AppColors.surfaceContainerHighest, height: 16),
          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng thanh toán', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
              Text(
                CurrencyFormatter.format(order.totalAmount),
                style: AppTypography.h3.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (order.status == OrderStatus.pending) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                context.read<ShopCubit>().updateOrderStatus(order.id, OrderStatus.cancelled);
              },
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Từ chối'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.read<ShopCubit>().updateOrderStatus(order.id, OrderStatus.preparing);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Nhận đơn'),
            ),
          ),
        ],
      );
    }

    if (order.status == OrderStatus.preparing) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.read<ShopCubit>().updateOrderStatus(order.id, OrderStatus.delivering);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Giao cho Shipper'),
        ),
      );
    }
    
    if (order.status == OrderStatus.delivering) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.read<ShopCubit>().updateOrderStatus(order.id, OrderStatus.completed);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
          child: const Text('Hoàn thành đơn'),
        ),
      );
    }

    return const SizedBox.shrink(); // No action for completed/cancelled
  }
}
