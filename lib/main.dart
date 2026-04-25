import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/core/router/app_router.dart';
import 'package:xfood/core/theme/app_theme.dart';
import 'package:xfood/features/shared/repositories/category_repository.dart';
import 'package:xfood/features/shared/repositories/order_repository.dart';
import 'package:xfood/features/shared/repositories/product_repository.dart';
import 'package:xfood/features/shared/repositories/shop_repository.dart';
import 'package:xfood/features/shared/repositories/user_repository.dart';
import 'package:xfood/features/shared/repositories/voucher_repository.dart';
import 'package:xfood/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:xfood/features/cart/presentation/bloc/checkout_cubit.dart';
import 'package:xfood/features/offers/presentation/bloc/offers_cubit.dart';
import 'package:xfood/features/shop_details/presentation/bloc/shop_detail_cubit.dart';
import 'package:xfood/features/user_home/presentation/bloc/home_cubit.dart';

void main() {
  runApp(const XfoodApp());
}

class XfoodApp extends StatelessWidget {
  const XfoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => UserRepository()),
        RepositoryProvider(create: (_) => CategoryRepository()),
        RepositoryProvider(create: (_) => ShopRepository()),
        RepositoryProvider(create: (_) => ProductRepository()),
        RepositoryProvider(create: (_) => VoucherRepository()),
        RepositoryProvider(create: (_) => OrderRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeCubit(
              userRepository: context.read<UserRepository>(),
              categoryRepository: context.read<CategoryRepository>(),
              shopRepository: context.read<ShopRepository>(),
              productRepository: context.read<ProductRepository>(),
            )..loadHomeData(),
          ),
          BlocProvider(
            create: (context) => CartCubit(),
          ),
          BlocProvider(
            create: (context) => ShopDetailCubit(
              shopRepository: context.read<ShopRepository>(),
              productRepository: context.read<ProductRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => OffersCubit(
              voucherRepository: context.read<VoucherRepository>(),
              productRepository: context.read<ProductRepository>(),
              shopRepository: context.read<ShopRepository>(),
            )..loadOffers(),
          ),
          BlocProvider(
            create: (context) => CheckoutCubit(
              orderRepository: context.read<OrderRepository>(),
              voucherRepository: context.read<VoucherRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Xfood',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark, // Ép buộc dùng Dark Mode cho theme Neon Mochi
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
