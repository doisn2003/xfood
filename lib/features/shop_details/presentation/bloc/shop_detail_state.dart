part of 'shop_detail_cubit.dart';

abstract class ShopDetailState extends Equatable {
  const ShopDetailState();

  @override
  List<Object> get props => [];
}

class ShopDetailInitial extends ShopDetailState {}

class ShopDetailLoading extends ShopDetailState {}

class ShopDetailLoaded extends ShopDetailState {
  final ShopModel shop;
  final List<ProductModel> products;

  const ShopDetailLoaded({required this.shop, required this.products});

  @override
  List<Object> get props => [shop, products];
}

class ShopDetailError extends ShopDetailState {
  final String message;

  const ShopDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
