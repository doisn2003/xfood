part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserModel user;
  final List<CategoryModel> categories;
  final List<ShopModel> popularShops; // This will be the filtered list
  final List<ShopModel> allShops; // Keeping full list for local filtering
  final List<ProductModel> allProducts; // Needed for filtering shops by product category
  final String? selectedCategoryId;

  const HomeLoaded({
    required this.user,
    required this.categories,
    required this.popularShops,
    required this.allShops,
    required this.allProducts,
    this.selectedCategoryId,
  });

  HomeLoaded copyWith({
    UserModel? user,
    List<CategoryModel>? categories,
    List<ShopModel>? popularShops,
    List<ShopModel>? allShops,
    List<ProductModel>? allProducts,
    String? selectedCategoryId,
    bool clearCategory = false,
  }) {
    return HomeLoaded(
      user: user ?? this.user,
      categories: categories ?? this.categories,
      popularShops: popularShops ?? this.popularShops,
      allShops: allShops ?? this.allShops,
      allProducts: allProducts ?? this.allProducts,
      selectedCategoryId: clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }

  @override
  List<Object> get props => [
        user,
        categories,
        popularShops,
        allShops,
        allProducts,
        selectedCategoryId ?? '',
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}
