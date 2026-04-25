part of 'product_detail_cubit.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductModel product;
  final ShopModel shop;
  final int quantity;

  const ProductDetailLoaded({
    required this.product,
    required this.shop,
    required this.quantity,
  });

  int get totalPrice => product.price * quantity;

  ProductDetailLoaded copyWith({
    ProductModel? product,
    ShopModel? shop,
    int? quantity,
  }) {
    return ProductDetailLoaded(
      product: product ?? this.product,
      shop: shop ?? this.shop,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, shop, quantity];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
