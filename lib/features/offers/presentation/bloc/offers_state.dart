part of 'offers_cubit.dart';

abstract class OffersState extends Equatable {
  const OffersState();

  @override
  List<Object> get props => [];
}

class OffersInitial extends OffersState {}

class OffersLoading extends OffersState {}

class OffersLoaded extends OffersState {
  final List<VoucherModel> vouchers;
  final List<ProductModel> products;
  final List<ShopModel> shops;

  const OffersLoaded({
    required this.vouchers,
    required this.products,
    required this.shops,
  });

  int get availableVoucherCount => vouchers.where((v) => !v.isUsed).length;

  ShopModel? getShopForProduct(ProductModel product) {
    try {
      return shops.firstWhere((s) => s.id == product.shopId);
    } catch (_) {
      return null;
    }
  }

  OffersLoaded copyWith({
    List<VoucherModel>? vouchers,
    List<ProductModel>? products,
    List<ShopModel>? shops,
  }) {
    return OffersLoaded(
      vouchers: vouchers ?? this.vouchers,
      products: products ?? this.products,
      shops: shops ?? this.shops,
    );
  }

  @override
  List<Object> get props => [vouchers, products, shops];
}

class OffersError extends OffersState {
  final String message;

  const OffersError({required this.message});

  @override
  List<Object> get props => [message];
}
