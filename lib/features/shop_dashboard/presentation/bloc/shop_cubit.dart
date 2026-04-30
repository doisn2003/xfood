import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/features/shared/models/order_model.dart';
import 'package:xfood/features/shared/models/product_model.dart';
import 'package:xfood/features/shared/models/shop_model.dart';
import 'package:xfood/features/shop_dashboard/models/revenue_model.dart';
import 'package:xfood/features/shop_dashboard/repositories/shop_dashboard_repository.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  final ShopDashboardRepository _repository;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  ShopCubit({required ShopDashboardRepository repository})
      : _repository = repository,
        super(const ShopState()) {
    _initData();
  }

  void _initData() async {
    emit(state.copyWith(status: ShopStatus.loading));
    try {
      final shopInfo = await _repository.getShopInfo();
      final products = await _repository.getShopProducts();
      final orders = await _repository.getShopOrders();
      final revenueSummary = await _repository.getRevenueSummary();
      final monthlyRevenue = await _repository.getMonthlyRevenue();
      
      emit(state.copyWith(
        status: ShopStatus.success,
        shopInfo: shopInfo,
        products: products,
        orders: orders,
        revenueSummary: revenueSummary,
        monthlyRevenue: monthlyRevenue,
      ));

      _listenToOrders();
    } catch (e) {
      emit(state.copyWith(status: ShopStatus.error, errorMessage: e.toString()));
    }
  }

  void _listenToOrders() {
    _ordersSubscription?.cancel();
    _ordersSubscription = _repository.getShopOrdersStream().listen((updatedOrders) {
      // Just update the orders list without changing other state
      emit(state.copyWith(orders: updatedOrders));
    });
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _repository.updateOrderStatus(orderId, newStatus);
      // State is updated automatically via stream
    } catch (e) {
      // Handle error visually if needed
    }
  }

  Future<void> toggleProductAvailability(String productId, bool isAvailable) async {
    try {
      await _repository.toggleProductAvailability(productId, isAvailable);
      // Optimistically update UI
      final updatedProducts = state.products.map((p) {
        if (p.id == productId) {
          return p.copyWith(isAvailable: isAvailable);
        }
        return p;
      }).toList();
      emit(state.copyWith(products: updatedProducts));
    } catch (e) {
      // Revert on error ideally
    }
  }

  Future<void> updateShopStatus(bool isOpen) async {
    if (state.shopInfo == null) return;
    try {
      final newShop = state.shopInfo!.copyWith(isOpen: isOpen);
      await _repository.updateShopInfo(newShop);
      emit(state.copyWith(shopInfo: newShop));
    } catch (e) {}
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await _repository.addProduct(product);
      final updatedProducts = List<ProductModel>.from(state.products)..add(product);
      emit(state.copyWith(products: updatedProducts));
    } catch (e) {}
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _repository.updateProduct(product);
      final updatedProducts = state.products.map((p) => p.id == product.id ? product : p).toList();
      emit(state.copyWith(products: updatedProducts));
    } catch (e) {}
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _repository.deleteProduct(productId);
      final updatedProducts = state.products.where((p) => p.id != productId).toList();
      emit(state.copyWith(products: updatedProducts));
    } catch (e) {}
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
