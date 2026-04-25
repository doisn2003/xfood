import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/features/shared/models/category_model.dart';
import 'package:xfood/features/shared/models/shop_model.dart';
import 'package:xfood/features/shared/models/product_model.dart';
import 'package:xfood/features/shared/models/user_model.dart';
import 'package:xfood/features/shared/repositories/category_repository.dart';
import 'package:xfood/features/shared/repositories/shop_repository.dart';
import 'package:xfood/features/shared/repositories/user_repository.dart';
import 'package:xfood/features/shared/repositories/product_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final ShopRepository _shopRepository;
  final ProductRepository _productRepository;

  HomeCubit({
    required UserRepository userRepository,
    required CategoryRepository categoryRepository,
    required ShopRepository shopRepository,
    required ProductRepository productRepository,
  })  : _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        _shopRepository = shopRepository,
        _productRepository = productRepository,
        super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final user = await _userRepository.getCurrentUser();
      final categories = await _categoryRepository.getCategories();
      final shops = await _shopRepository.getPopularShops();
      final products = await _productRepository.getAllProducts();
      
      emit(HomeLoaded(
        user: user,
        categories: categories,
        popularShops: shops,
        allShops: shops,
        allProducts: products,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  void selectCategory(String? categoryId) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      if (currentState.selectedCategoryId == categoryId) {
        // Deselect if tapping the same category
        emit(currentState.copyWith(
          popularShops: currentState.allShops,
          clearCategory: true,
        ));
      } else {
        // Filter shops by category ID (Checking if any product in the shop matches the category)
        final filteredShops = categoryId == null 
            ? currentState.allShops 
            : currentState.allShops.where((shop) {
                return currentState.allProducts.any((p) => p.shopId == shop.id && p.categoryId == categoryId);
              }).toList();
            
        emit(currentState.copyWith(
          selectedCategoryId: categoryId,
          popularShops: filteredShops,
          clearCategory: categoryId == null,
        ));
      }
    }
  }
}
