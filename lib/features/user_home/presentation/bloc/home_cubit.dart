import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/features/shared/models/category_model.dart';
import 'package:xfood/features/shared/models/shop_model.dart';
import 'package:xfood/features/shared/models/user_model.dart';
import 'package:xfood/features/shared/repositories/category_repository.dart';
import 'package:xfood/features/shared/repositories/shop_repository.dart';
import 'package:xfood/features/shared/repositories/user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final ShopRepository _shopRepository;

  HomeCubit({
    required UserRepository userRepository,
    required CategoryRepository categoryRepository,
    required ShopRepository shopRepository,
  })  : _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        _shopRepository = shopRepository,
        super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final user = await _userRepository.getCurrentUser();
      final categories = await _categoryRepository.getCategories();
      final shops = await _shopRepository.getPopularShops();
      
      emit(HomeLoaded(
        user: user,
        categories: categories,
        popularShops: shops,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
