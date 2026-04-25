import 'package:xfood/data_sources/env.dart';
import 'package:xfood/data_sources/mock_server/mock_database.dart';
import 'package:xfood/features/shared/models/order_model.dart';

class OrderRepository {
  Future<void> placeOrder(OrderModel order) async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    MockDatabase.instance.placeOrder(order);
  }

  Future<List<OrderModel>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    return MockDatabase.instance.orders;
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    try {
      return MockDatabase.instance.orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs ~/ 2));
    MockDatabase.instance.updateOrderStatus(orderId, status);
  }

  Future<void> removeOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs ~/ 2));
    MockDatabase.instance.removeOrder(orderId);
  }
}
