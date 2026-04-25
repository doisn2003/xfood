import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:xfood/features/orders/presentation/bloc/orders_cubit.dart';

class MainLayoutScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayoutScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              currentIndex: navigationShell.currentIndex,
              onTap: _onTap,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.house),
                  activeIcon: Icon(CupertinoIcons.house_fill),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.ticket),
                  activeIcon: Icon(CupertinoIcons.ticket_fill),
                  label: 'Ưu Đãi',
                ),
                BottomNavigationBarItem(
                  icon: BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) {
                      final count = state.activeOrders.length;
                      return Badge(
                        label: Text('$count'),
                        isLabelVisible: count > 0,
                        backgroundColor: AppColors.tertiary,
                        textColor: AppColors.textDark,
                        child: const Icon(CupertinoIcons.doc_text),
                      );
                    },
                  ),
                  activeIcon: BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) {
                      final count = state.activeOrders.length;
                      return Badge(
                        label: Text('$count'),
                        isLabelVisible: count > 0,
                        backgroundColor: AppColors.tertiary,
                        textColor: AppColors.textDark,
                        child: const Icon(CupertinoIcons.doc_text_fill),
                      );
                    },
                  ),
                  label: 'Đơn Hàng',
                ),
                BottomNavigationBarItem(
                  icon: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      return Badge(
                        label: Text('${state.totalItems}'),
                        isLabelVisible: state.items.isNotEmpty,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.textDark,
                        child: const Icon(CupertinoIcons.cart),
                      );
                    },
                  ),
                  activeIcon: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      return Badge(
                        label: Text('${state.totalItems}'),
                        isLabelVisible: state.items.isNotEmpty,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.textDark,
                        child: const Icon(CupertinoIcons.cart_fill),
                      );
                    },
                  ),
                  label: 'Giỏ Hàng',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  activeIcon: Icon(CupertinoIcons.person_solid),
                  label: 'Tôi',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
