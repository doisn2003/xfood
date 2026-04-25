import 'package:xfood/features/shared/models/order_model.dart';
import 'package:xfood/features/shared/models/product_model.dart';
import 'package:xfood/features/shared/models/shop_model.dart';
import 'package:xfood/features/shared/models/user_model.dart';
import 'package:xfood/features/shared/models/voucher_model.dart';
import 'package:xfood/features/shared/models/category_model.dart';

/// Singleton In-Memory Database to share state across User/Shop app
class MockDatabase {
  MockDatabase._privateConstructor();
  static final MockDatabase instance = MockDatabase._privateConstructor();

  // --- MOCK USERS ---
  final UserModel currentUser = const UserModel(
    id: 'u_1',
    name: 'Cú Đêm',
    phone: '0987654321',
    avatarUrl: 'assets/images/mock/user_avatar.png',
    rewardPoints: 1500,
  );

  // --- MOCK CATEGORIES ---
  final List<CategoryModel> categories = [
    const CategoryModel(id: 'c_1', name: 'Bún/Phở', iconUrl: 'ramen_dining'),
    const CategoryModel(id: 'c_2', name: 'Ăn vặt', iconUrl: 'fastfood'),
    const CategoryModel(id: 'c_3', name: 'Đồ uống', iconUrl: 'local_drink'),
  ];

  // --- MOCK SHOPS ---
  final List<ShopModel> shops = [
    const ShopModel(
      id: 's_1',
      name: 'Mì Cay Sasin - Khuya',
      address: '123 Cầu Giấy',
      imageUrl: 'assets/images/mock/shop_1.png',
      isOpen: true,
      rating: 4.8,
      baseShippingFee: 15000,
      feePerKm: 5000,
      categories: ['c_1'],
    ),
    const ShopModel(
      id: 's_2',
      name: 'Trà Sữa Cú Đêm',
      address: '456 Đê La Thành',
      imageUrl: 'assets/images/mock/shop_2.png',
      isOpen: true,
      rating: 4.5,
      baseShippingFee: 10000,
      feePerKm: 3000,
      categories: ['c_3'],
    ),
  ];

  // --- MOCK PRODUCTS ---
  final List<ProductModel> products = [
    const ProductModel(
      id: 'p_1',
      shopId: 's_1',
      categoryId: 'c_1',
      name: 'Mì Cay Hải Sản Cấp 7',
      description: 'Cay xé lưỡi, tỉnh ngủ ngay lập tức.',
      imageUrl: 'assets/images/mock/product_1.png',
      price: 55000,
    ),
    const ProductModel(
      id: 'p_2',
      shopId: 's_2',
      categoryId: 'c_3',
      name: 'Trà Sữa Trân Châu Đường Đen',
      description: 'Ngọt ngào giữa đêm khuya.',
      imageUrl: 'assets/images/mock/product_2.png',
      price: 35000,
    ),
  ];

  // --- MOCK VOUCHERS ---
  final List<VoucherModel> vouchers = [
    const VoucherModel(
      id: 'v_1',
      code: 'DEMKHUYA',
      description: 'Giảm 20k cho đơn từ 100k',
      discountAmount: 20000,
    ),
    const VoucherModel(
      id: 'v_2',
      code: 'FREESHIP',
      description: 'Miễn phí giao hàng 15k',
      discountAmount: 15000,
      isFreeship: true,
    ),
  ];

  // --- IN-MEMORY ORDERS STATE ---
  final List<OrderModel> orders = [];

  // Helper function to simulate adding an order
  void placeOrder(OrderModel order) {
    orders.add(order);
  }
}
