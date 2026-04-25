import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/features/shared/models/order_model.dart';
import 'package:xfood/features/shared/models/shop_model.dart';
import 'package:xfood/features/shared/repositories/order_repository.dart';
import 'package:xfood/features/shared/repositories/shop_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepository orderRepository;
  final ShopRepository shopRepository;

  OrdersCubit({
    required this.orderRepository,
    required this.shopRepository,
  }) : super(const OrdersState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final shops = await shopRepository.getPopularShops();
      final orders = await orderRepository.getOrders();
      emit(state.copyWith(
        isLoading: false,
        shops: shops,
        activeOrders: orders.where((o) => o.status != OrderStatus.completed).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Mỗi lần refresh sẽ tiến trình đơn hàng đang active lên 1 bước.
  /// Refresh 1: pending → preparing
  /// Refresh 2: preparing → delivering
  /// Refresh 3: delivering → completed → xóa khỏi list
  Future<void> refresh() async {
    // Reload orders from MockDatabase first
    final orders = await orderRepository.getOrders();
    final activeOrders = orders.where((o) => o.status != OrderStatus.completed).toList();

    if (activeOrders.isEmpty) {
      emit(state.copyWith(activeOrders: []));
      return;
    }

    // Progress the first active order
    final currentOrder = activeOrders.first;
    final newRefreshCount = state.refreshCount + 1;

    OrderStatus nextStatus;
    bool orderCompleted = false;

    switch (currentOrder.status) {
      case OrderStatus.pending:
        nextStatus = OrderStatus.preparing;
        break;
      case OrderStatus.preparing:
        nextStatus = OrderStatus.delivering;
        break;
      case OrderStatus.delivering:
        nextStatus = OrderStatus.completed;
        orderCompleted = true;
        break;
      default:
        nextStatus = currentOrder.status;
    }

    // Update in MockDatabase
    await orderRepository.updateOrderStatus(currentOrder.id, nextStatus);

    if (orderCompleted) {
      // Remove from MockDatabase after marking complete
      await orderRepository.removeOrder(currentOrder.id);
      final updatedOrders = await orderRepository.getOrders();
      emit(state.copyWith(
        refreshCount: 0,
        activeOrders: updatedOrders.where((o) => o.status != OrderStatus.completed).toList(),
        completedOrderName: currentOrder.items.isNotEmpty
            ? currentOrder.items.first.productName
            : 'Đơn hàng',
      ));
    } else {
      final updatedOrders = await orderRepository.getOrders();
      emit(state.copyWith(
        refreshCount: newRefreshCount,
        activeOrders: updatedOrders.where((o) => o.status != OrderStatus.completed).toList(),
        completedOrderName: '',
      ));
    }
  }

  void clearCompletedNotification() {
    emit(state.copyWith(completedOrderName: ''));
  }
}
