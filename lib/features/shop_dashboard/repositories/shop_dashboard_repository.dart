import 'dart:async';
import 'package:xfood/data_sources/mock_server/mock_database.dart';
import 'package:xfood/features/shared/models/order_model.dart';
import 'package:xfood/features/shared/models/product_model.dart';
import 'package:xfood/features/shared/models/shop_model.dart';

class ShopDashboardRepository {
  final _db = MockDatabase.instance;
  final String _mockShopId = 's_6'; // Default mock shop id for this phase

  // Get stream of orders for the mock shop
  Stream<List<OrderModel>> getShopOrdersStream() {
    return _db.ordersStream.map(
      (orders) => orders.where((o) => o.shopId == _mockShopId).toList(),
    );
  }

  // Get initial list of orders
  Future<List<OrderModel>> getShopOrders() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Mock delay
    return _db.orders.where((o) => o.shopId == _mockShopId).toList();
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _db.updateOrderStatus(orderId, status);
  }

  // Get shop details
  Future<ShopModel> getShopInfo() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _db.shops.firstWhere((s) => s.id == _mockShopId);
  }

  // Update shop details
  Future<void> updateShopInfo(ShopModel shop) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _db.updateShop(shop);
  }

  // Get shop products
  Future<List<ProductModel>> getShopProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _db.products.where((p) => p.shopId == _mockShopId).toList();
  }

  // Toggle product availability
  Future<void> toggleProductAvailability(String productId, bool isAvailable) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _db.toggleProductAvailability(productId, isAvailable);
  }
}
