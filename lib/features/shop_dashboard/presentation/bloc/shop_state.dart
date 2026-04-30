part of 'shop_cubit.dart';

enum ShopStatus { initial, loading, success, error }

class ShopState extends Equatable {
  final ShopStatus status;
  final ShopModel? shopInfo;
  final List<ProductModel> products;
  final List<OrderModel> orders;
  final RevenueSummaryModel? revenueSummary;
  final List<MonthlyRevenueData> monthlyRevenue;
  final String? errorMessage;

  const ShopState({
    this.status = ShopStatus.initial,
    this.shopInfo,
    this.products = const [],
    this.orders = const [],
    this.revenueSummary,
    this.monthlyRevenue = const [],
    this.errorMessage,
  });

  ShopState copyWith({
    ShopStatus? status,
    ShopModel? shopInfo,
    List<ProductModel>? products,
    List<OrderModel>? orders,
    RevenueSummaryModel? revenueSummary,
    List<MonthlyRevenueData>? monthlyRevenue,
    String? errorMessage,
  }) {
    return ShopState(
      status: status ?? this.status,
      shopInfo: shopInfo ?? this.shopInfo,
      products: products ?? this.products,
      orders: orders ?? this.orders,
      revenueSummary: revenueSummary ?? this.revenueSummary,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, shopInfo, products, orders, revenueSummary, monthlyRevenue, errorMessage];
}
