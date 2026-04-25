import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/features/shared/models/product_model.dart';
import 'package:xfood/features/shared/models/shop_model.dart';
import 'package:xfood/features/shared/repositories/product_repository.dart';
import 'package:xfood/features/shared/repositories/shop_repository.dart';

part 'shop_detail_state.dart';

class ShopDetailCubit extends Cubit<ShopDetailState> {
  final ShopRepository _shopRepository;
  final ProductRepository _productRepository;

  ShopDetailCubit({
    required ShopRepository shopRepository,
    required ProductRepository productRepository,
  })  : _shopRepository = shopRepository,
        _productRepository = productRepository,
        super(ShopDetailInitial());

  Future<void> loadShopDetails(String shopId) async {
    emit(ShopDetailLoading());
    try {
      final shop = await _shopRepository.getShopById(shopId);
      final products = await _productRepository.getProductsByShopId(shopId);
      
      emit(ShopDetailLoaded(shop: shop, products: products));
    } catch (e) {
      emit(ShopDetailError(message: e.toString()));
    }
  }
}
