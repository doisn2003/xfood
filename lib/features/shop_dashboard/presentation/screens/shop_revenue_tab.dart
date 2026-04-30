import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/shared/models/order_model.dart';
import 'package:xfood/features/shop_dashboard/presentation/bloc/shop_cubit.dart';
import 'package:xfood/core/utils/currency_formatter.dart';

class ShopRevenueTab extends StatelessWidget {
  const ShopRevenueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê Doanh thu'),
        centerTitle: true,
      ),
      body: BlocBuilder<ShopCubit, ShopState>(
        builder: (context, state) {
          if (state.status == ShopStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final completedOrders = state.orders.where((o) => o.status == OrderStatus.completed).toList();
          final totalRevenue = completedOrders.fold<int>(0, (sum, o) => sum + o.totalAmount);
          final pendingOrders = state.orders.where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.preparing).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatCard('Tổng doanh thu', CurrencyFormatter.format(totalRevenue), AppColors.primary, Icons.monetization_on),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Đơn hoàn thành', '${completedOrders.length}', AppColors.success, Icons.check_circle)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard('Đang xử lý', '${pendingOrders.length}', AppColors.warning, Icons.pending_actions)),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Biểu đồ Mock', style: AppTypography.h3),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Đồ thị hiển thị ở phiên bản thật', style: AppTypography.caption),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: AppTypography.caption)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTypography.h2.copyWith(color: color)),
        ],
      ),
    );
  }
}
