import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/features/shared/models/product_model.dart';
import 'package:xfood/features/shared/models/shop_model.dart';
import 'package:xfood/features/shared/repositories/product_repository.dart';
import 'package:xfood/features/shared/repositories/shop_repository.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductRepository _productRepository;
  final ShopRepository _shopRepository;

  ProductDetailCubit({
    required ProductRepository productRepository,
    required ShopRepository shopRepository,
  })  : _productRepository = productRepository,
        _shopRepository = shopRepository,
        super(ProductDetailInitial());

  Future<void> loadProduct(String productId) async {
    emit(ProductDetailLoading());
    try {
      final allProducts = await _productRepository.getAllProducts();
      final product = allProducts.firstWhere((p) => p.id == productId);
      final shop = await _shopRepository.getShopById(product.shopId);

      emit(ProductDetailLoaded(
        product: product,
        shop: shop,
        quantity: 1,
      ));
    } catch (e) {
      emit(ProductDetailError(message: e.toString()));
    }
  }

  void incrementQuantity() {
    final currentState = state;
    if (currentState is ProductDetailLoaded) {
      emit(currentState.copyWith(quantity: currentState.quantity + 1));
    }
  }

  void decrementQuantity() {
    final currentState = state;
    if (currentState is ProductDetailLoaded && currentState.quantity > 1) {
      emit(currentState.copyWith(quantity: currentState.quantity - 1));
    }
  }
}
