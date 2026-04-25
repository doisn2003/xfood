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
  final List<ShopModel> popularShops;

  const HomeLoaded({
    required this.user,
    required this.categories,
    required this.popularShops,
  });

  @override
  List<Object> get props => [user, categories, popularShops];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}
