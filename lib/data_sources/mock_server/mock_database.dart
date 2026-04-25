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
    const CategoryModel(id: 'c_1', name: 'Bún/Phở', iconUrl: '🍜'),
    const CategoryModel(id: 'c_4', name: 'Mỳ', iconUrl: '🍝'),
    const CategoryModel(id: 'c_2', name: 'Ăn vặt', iconUrl: '🍟'),
    const CategoryModel(id: 'c_3', name: 'Đồ uống', iconUrl: '🧋'),
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
    ),
    const ShopModel(
      id: 's_3',
      name: 'Phở Gà Chặt Khuya',
      address: '789 Láng Hạ',
      imageUrl: 'assets/images/mock/banner_pho_ga.png',
      isOpen: true,
      rating: 4.9,
      baseShippingFee: 20000,
      feePerKm: 5000,
    ),
    const ShopModel(
      id: 's_4',
      name: 'Khô Gà Mixi',
      address: 'Độ Phùng Khoang',
      imageUrl: 'assets/images/mock/banner_kho_ga.png',
      isOpen: true,
      rating: 5.0,
      baseShippingFee: 0,
      feePerKm: 4000,
    ),
    const ShopModel(
      id: 's_5',
      name: 'Sinh Tố Cú Đêm',
      address: '22 Xã Đàn',
      imageUrl: 'assets/images/mock/banner_sinh_to.png',
      isOpen: true,
      rating: 4.7,
      baseShippingFee: 15000,
      feePerKm: 3000,
    ),
  ];

  // --- MOCK PRODUCTS ---
  final List<ProductModel> products = [
    const ProductModel(
      id: 'p_1',
      shopId: 's_1',
      categoryId: 'c_4',
      name: 'Mì Cay Hải Sản 7 Cấp',
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
    const ProductModel(
      id: 'p_3',
      shopId: 's_3',
      categoryId: 'c_1',
      name: 'Phở Gà Đùi Chặt Đặc Biệt',
      description: 'Nước dùng thanh ngọt, thịt gà dai giòn, xua tan cái lạnh đêm khuya.',
      imageUrl: 'assets/images/mock/banner_pho_ga.png',
      price: 65000,
    ),
    const ProductModel(
      id: 'p_4',
      shopId: 's_4',
      categoryId: 'c_2',
      name: 'Khô Gà Lá Chanh 500g',
      description: 'Giòn rụm, cay nhẹ, đồ nhắm chân ái cho game thủ cày rank đêm.',
      imageUrl: 'assets/images/mock/banner_kho_ga.png',
      price: 120000,
    ),
    const ProductModel(
      id: 'p_5',
      shopId: 's_5',
      categoryId: 'c_3',
      name: 'Sinh Tố Bơ Xoài Dầm',
      description: 'Vitamin tươi mát, chua ngọt hòa quyện, giải nhiệt siêu tốc.',
      imageUrl: 'assets/images/mock/banner_sinh_to.png',
      price: 45000,
    ),
  ];

  // --- MOCK VOUCHERS (Mutable for in-memory state) ---
  final List<VoucherModel> vouchers = [
    const VoucherModel(
      id: 'v_1',
      code: 'DEMKHUYA',
      description: 'Giảm 20k cho đơn từ 100k',
      discountAmount: 20000,
      minOrderAmount: 100000,
    ),
    const VoucherModel(
      id: 'v_2',
      code: 'FREESHIP',
      description: 'Miễn phí giao hàng 15k',
      discountAmount: 15000,
      isFreeship: true,
    ),
    const VoucherModel(
      id: 'v_3',
      code: 'CU30K',
      description: 'Giảm 30k cho đơn từ 150k',
      discountAmount: 30000,
      minOrderAmount: 150000,
    ),
    const VoucherModel(
      id: 'v_4',
      code: 'NEWBIE10',
      description: 'Giảm 10k cho tất cả đơn',
      discountAmount: 10000,
    ),
    const VoucherModel(
      id: 'v_5',
      code: 'MIDNIGHT50',
      description: 'Giảm 50k cho đơn từ 200k',
      discountAmount: 50000,
      minOrderAmount: 200000,
    ),
    const VoucherModel(
      id: 'v_6',
      code: 'FREESHIP2',
      description: 'Miễn phí giao hàng 20k',
      discountAmount: 20000,
      isFreeship: true,
    ),
  ];

  // --- IN-MEMORY ORDERS STATE ---
  final List<OrderModel> orders = [];

  // Helper: Mark voucher as used
  void useVoucher(String voucherId) {
    final index = vouchers.indexWhere((v) => v.id == voucherId);
    if (index >= 0) {
      vouchers[index] = vouchers[index].copyWith(isUsed: true);
    }
  }

  // Helper: Add voucher (reward from lucky wheel)
  void addVoucher(VoucherModel voucher) {
    vouchers.add(voucher);
  }

  // Helper: Clear all vouchers from lucky wheel and reset used status
  void clearRewardVouchers() {
    // 1. Remove vouchers added by wheel (ID starts with v_reward_)
    vouchers.removeWhere((v) => v.id.startsWith('v_reward_') || v.id.startsWith('v_bonus_'));
    
    // 2. Reset isUsed status for remaining original vouchers
    for (int i = 0; i < vouchers.length; i++) {
      vouchers[i] = vouchers[i].copyWith(isUsed: false);
    }
  }

  // Helper function to simulate adding an order
  void placeOrder(OrderModel order) {
    orders.add(order);
  }
}
