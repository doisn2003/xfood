import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/features/shop_dashboard/presentation/bloc/shop_cubit.dart';
import 'package:xfood/features/shop_dashboard/presentation/screens/shop_home_tab.dart';
import 'package:xfood/features/shop_dashboard/presentation/screens/shop_products_tab.dart';
import 'package:xfood/features/shop_dashboard/presentation/screens/shop_revenue_tab.dart';
import 'package:xfood/features/shop_dashboard/presentation/screens/shop_profile_tab.dart';
import 'package:xfood/features/shop_dashboard/repositories/shop_dashboard_repository.dart';

class ShopDashboardScreen extends StatelessWidget {
  const ShopDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ShopDashboardRepository(),
      child: BlocProvider(
        create: (context) => ShopCubit(
          repository: context.read<ShopDashboardRepository>(),
        ),
        child: const _ShopDashboardView(),
      ),
    );
  }
}

class _ShopDashboardView extends StatefulWidget {
  const _ShopDashboardView();

  @override
  State<_ShopDashboardView> createState() => _ShopDashboardViewState();
}

class _ShopDashboardViewState extends State<_ShopDashboardView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Read initial tab from URL query parameters safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = GoRouterState.of(context);
        final tab = state.uri.queryParameters['tab'];
        if (tab != null) {
          final index = int.tryParse(tab);
          if (index != null && index >= 0 && index < _tabs.length) {
            setState(() {
              _currentIndex = index;
            });
          }
        }
      }
    });
  }

  final List<Widget> _tabs = [
    const ShopHomeTab(),
    const ShopProductsTab(),
    const ShopRevenueTab(),
    const ShopProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.backgroundDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Đơn hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Quán'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Doanh thu'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tôi'),
        ],
      ),
    );
  }
}
