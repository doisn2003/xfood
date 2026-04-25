part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  final bool isLoading;
  final List<ShopModel> shops;
  final List<OrderModel> activeOrders;
  final int refreshCount;
  final String completedOrderName; // Non-empty = just completed

  const OrdersState({
    this.isLoading = false,
    this.shops = const [],
    this.activeOrders = const [],
    this.refreshCount = 0,
    this.completedOrderName = '',
  });

  bool get hasActiveOrder => activeOrders.isNotEmpty;

  OrderModel? get currentOrder => activeOrders.isNotEmpty ? activeOrders.first : null;

  /// Trạng thái hiển thị của đơn hàng đang active
  String get statusText {
    if (currentOrder == null) return '';
    switch (currentOrder!.status) {
      case OrderStatus.pending:
        return 'Đang chờ xác nhận...';
      case OrderStatus.preparing:
        return 'Nhà hàng đang chuẩn bị 🍳';
      case OrderStatus.delivering:
        return 'Shipper đang giao đến bạn 🚴';
      case OrderStatus.completed:
        return 'Đã giao thành công! ✅';
      case OrderStatus.cancelled:
        return 'Đã hủy';
    }
  }

  /// Progress (0.0 → 1.0) cho tracking bar
  double get trackingProgress {
    if (currentOrder == null) return 0;
    switch (currentOrder!.status) {
      case OrderStatus.pending:
        return 0.15;
      case OrderStatus.preparing:
        return 0.45;
      case OrderStatus.delivering:
        return 0.75;
      case OrderStatus.completed:
        return 1.0;
      case OrderStatus.cancelled:
        return 0;
    }
  }

  OrdersState copyWith({
    bool? isLoading,
    List<ShopModel>? shops,
    List<OrderModel>? activeOrders,
    int? refreshCount,
    String? completedOrderName,
  }) {
    return OrdersState(
      isLoading: isLoading ?? this.isLoading,
      shops: shops ?? this.shops,
      activeOrders: activeOrders ?? this.activeOrders,
      refreshCount: refreshCount ?? this.refreshCount,
      completedOrderName: completedOrderName ?? this.completedOrderName,
    );
  }

  @override
  List<Object?> get props => [isLoading, shops, activeOrders, refreshCount, completedOrderName];
}
