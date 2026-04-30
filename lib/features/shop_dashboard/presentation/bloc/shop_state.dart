part of 'shop_cubit.dart';

enum ShopStatus { initial, loading, success, error }

class ShopState extends Equatable {
  final ShopStatus status;
  final ShopModel? shopInfo;
  final List<ProductModel> products;
  final List<OrderModel> orders;
  final String? errorMessage;

  const ShopState({
    this.status = ShopStatus.initial,
    this.shopInfo,
    this.products = const [],
    this.orders = const [],
    this.errorMessage,
  });

  ShopState copyWith({
    ShopStatus? status,
    ShopModel? shopInfo,
    List<ProductModel>? products,
    List<OrderModel>? orders,
    String? errorMessage,
  }) {
    return ShopState(
      status: status ?? this.status,
      shopInfo: shopInfo ?? this.shopInfo,
      products: products ?? this.products,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, shopInfo, products, orders, errorMessage];
}
