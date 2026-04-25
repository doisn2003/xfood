import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/features/main_layout/presentation/main_layout_screen.dart';
import 'package:xfood/features/offers/presentation/offers_screen.dart';
import 'package:xfood/features/orders/presentation/orders_screen.dart';
import 'package:xfood/features/cart/presentation/cart_screen.dart';
import 'package:xfood/features/profile/presentation/profile_screen.dart';
import 'package:xfood/features/shop_dashboard/presentation/shop_dashboard_screen.dart';
import 'package:xfood/features/shop_details/presentation/shop_detail_screen.dart';
import 'package:xfood/features/user_home/presentation/home_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorOffers = GlobalKey<NavigatorState>(debugLabel: 'shellOffers');
final GlobalKey<NavigatorState> _shellNavigatorOrders = GlobalKey<NavigatorState>(debugLabel: 'shellOrders');
final GlobalKey<NavigatorState> _shellNavigatorCart = GlobalKey<NavigatorState>(debugLabel: 'shellCart');
final GlobalKey<NavigatorState> _shellNavigatorProfile = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayoutScreen(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHome,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'shop_details/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final shopId = state.pathParameters['id']!;
                    return ShopDetailScreen(shopId: shopId);
                  },
                ),
              ],
            ),
          ],
        ),
        // Tab 2: Offers
        StatefulShellBranch(
          navigatorKey: _shellNavigatorOffers,
          routes: [
            GoRoute(
              path: '/offers',
              builder: (context, state) => const OffersScreen(),
            ),
          ],
        ),
        // Tab 3: Orders
        StatefulShellBranch(
          navigatorKey: _shellNavigatorOrders,
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
        // Tab 4: Cart
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCart,
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        // Tab 5: Profile
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfile,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    
    // Shop Routes (Outside of Main Layout)
    GoRoute(
      path: '/shop_dashboard',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ShopDashboardScreen(),
    ),
  ],
);
