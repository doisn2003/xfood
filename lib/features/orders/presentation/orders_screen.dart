import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/orders/presentation/bloc/orders_cubit.dart';
import 'package:xfood/features/orders/presentation/widgets/order_detail_sheet.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final MapController _mapController = MapController();
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadData();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return '${buffer}đ';
  }

  void _showOrderDetail(BuildContext context, order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: OrderDetailSheet(order: order),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Trung tâm Hà Nội
    const hanoiCenter = LatLng(21.0150, 105.8100);

    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state.completedOrderName.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '🎉 Giao hàng thành công! Chúc bạn ngon miệng!',
                style: const TextStyle(color: AppColors.textDark),
              ),
              backgroundColor: AppColors.tertiary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              duration: const Duration(seconds: 3),
            ),
          );
          context.read<OrdersCubit>().clearCompletedNotification();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                // ─── BẢN ĐỒ ───
                FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    initialCenter: hanoiCenter,
                    initialZoom: 13.0,
                    maxZoom: 18.0,
                    minZoom: 10.0,
                  ),
                  children: [
                    // ─── LỚP BẢN ĐỒ SÁNG (Dưới) ───
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.xfood.app',
                      maxZoom: 19,
                    ),

                    // ─── LỚP BẢN ĐỒ TỐI (Trên) ───
                    Opacity(
                      opacity: _isDarkMode ? 1.0 : 0.0,
                      child: TileLayer(
                        urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.xfood.app',
                        maxZoom: 19,
                      ),
                    ),

                    // Shop markers
                    MarkerLayer(
                      markers: state.shops.map((shop) {
                        return Marker(
                          point: LatLng(shop.latitude, shop.longitude),
                          width: 120,
                          height: 55,
                          child: GestureDetector(
                            onTap: () => context.push('/home/shop_details/${shop.id}'),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Shop name label
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLow.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    shop.name,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Pin icon
                                const Icon(
                                  CupertinoIcons.map_pin_ellipse,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // ─── HEADER ───
                Positioned(
                  top: 8,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.map_fill, color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Đơn Hàng & Bản Đồ',
                            style: AppTypography.subtitle.copyWith(color: AppColors.primary),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.read<OrdersCubit>().refresh(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              CupertinoIcons.refresh,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── MAP CONTROLS (Dưới bên phải) ───
                Positioned(
                  right: 16,
                  bottom: state.hasActiveOrder ? 140 : 80, // Đẩy lên nếu có tracking bar
                  child: Column(
                    children: [
                      // Nút La Bàn
                      _buildMapControl(
                        icon: CupertinoIcons.compass,
                        onTap: () {
                          _mapController.rotate(0); // Quay về hướng Bắc
                        },
                      ),
                      const SizedBox(height: 12),
                      // Nút Vị Trí
                      _buildMapControl(
                        icon: CupertinoIcons.location_fill,
                        onTap: () {
                          
                        },
                      ),
                      const SizedBox(height: 12),
                      // Nút Bóng Đèn (Dark/Light Mode)
                      _buildMapControl(
                        icon: _isDarkMode ? CupertinoIcons.lightbulb : CupertinoIcons.lightbulb_fill,
                        onTap: () {
                          setState(() {
                            _isDarkMode = !_isDarkMode;
                          });
                        },
                        isActive: !_isDarkMode,
                      ),
                    ],
                  ),
                ),

                // ─── TRACKING BAR ───
                if (state.hasActiveOrder)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => _showOrderDetail(context, state.currentOrder!),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, -4),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Order name + status
                            Row(
                              children: [
                                // Icon
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: Text('🍜', style: TextStyle(fontSize: 20)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.currentOrder!.items.isNotEmpty
                                            ? state.currentOrder!.items.first.productName
                                            : 'Đơn hàng',
                                        style: AppTypography.subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        state.statusText,
                                        style: AppTypography.caption.copyWith(color: AppColors.tertiary),
                                      ),
                                    ],
                                  ),
                                ),
                                // Total
                                Text(
                                  _formatPrice(state.currentOrder!.totalAmount),
                                  style: AppTypography.subtitle.copyWith(color: AppColors.primary),
                                ),
                                const SizedBox(width: 4),
                                const Icon(CupertinoIcons.chevron_right, color: AppColors.textSecondary, size: 16),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: state.trackingProgress,
                                backgroundColor: AppColors.surfaceContainerHigh,
                                color: AppColors.primary,
                                minHeight: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ─── EMPTY STATE ───
                if (!state.hasActiveOrder && !state.isLoading)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('😴', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Text(
                            'Chưa có đơn hàng nào',
                            style: AppTypography.bodySecondary,
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
    );
  }

  Widget _buildMapControl({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.primary 
              : AppColors.surfaceContainerLow.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? Colors.transparent : AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.textDark : AppColors.primary,
          size: 22,
        ),
      ),
    );
  }
}
