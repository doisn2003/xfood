import 'dart:async';
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
    const CategoryModel(id: 'c_5', name: 'Cơm', iconUrl: '🍚'),
  ];

  // --- MOCK SHOPS (with real Hanoi coordinates) ---
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
      latitude: 21.0285,
      longitude: 105.7823,
      description: 'Chuyên các loại mì cay Hàn Quốc chuẩn vị 7 cấp độ, phục vụ xuyên đêm.',
      openingHours: '18:00 - 04:00',
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
      latitude: 21.0228,
      longitude: 105.8135,
      description: 'Trà sữa đậm vị trà, topping đa dạng. Lý tưởng cho các tín đồ thức khuya cày phim.',
      openingHours: '20:00 - 05:00',
    ),
    const ShopModel(
      id: 's_3',
      name: 'Phở Gà Chuẩn Hà Nội',
      address: '789 Láng Hạ',
      imageUrl: 'assets/images/mock/banner_pho_ga.png',
      isOpen: true,
      rating: 4.9,
      baseShippingFee: 20000,
      feePerKm: 5000,
      latitude: 21.0128,
      longitude: 105.8120,
      description: 'Phở gà ta chuẩn vị Bắc, nước dùng thanh ngọt nấu từ xương hầm 24h.',
      openingHours: '19:00 - 03:00',
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
      latitude: 20.9970,
      longitude: 105.7960,
      description: 'Khô gà lá chanh, khô heo cháy tỏi siêu ngon nhức nách. Nhắm rượu bia bao cuốn.',
      openingHours: '10:00 - 02:00',
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
      latitude: 21.0170,
      longitude: 105.8290,
      description: 'Sinh tố trái cây tươi nguyên chất 100%, không pha siro, tốt cho sức khỏe.',
      openingHours: '17:00 - 02:00',
    ),
    const ShopModel(
      id: 's_6',
      name: 'Cơm rang Lò Đúc',
      address: '127 Lò Đúc',
      imageUrl: 'assets/images/mock/com_rang_lo_duc_shop.png',
      isOpen: true,
      rating: 4.6,
      baseShippingFee: 15000,
      feePerKm: 4000,
      latitude: 21.0145,
      longitude: 105.8562,
      description: 'Cơm rang lâu đời, hạt cơm săn chắc, đậm đà, thơm lừng.',
      openingHours: '10:00 - 23:00',
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
    const ProductModel(
      id: 'p_6',
      shopId: 's_6',
      categoryId: 'c_5',
      name: 'Cơm rang thập cẩm',
      description: 'Cơm rang dẻo thơm cùng lạp xưởng, trứng, rau củ và tôm khô.',
      imageUrl: 'assets/images/mock/com_rang_thap_cam.png',
      price: 45000,
    ),
    const ProductModel(
      id: 'p_7',
      shopId: 's_6',
      categoryId: 'c_5',
      name: 'Cơm rang dưa chua thịt bò',
      description: 'Cơm rang dưa chua thịt bò đậm vị, chua thanh chống ngán.',
      imageUrl: 'assets/images/mock/com_rang_dua_chua_thit_bo.png',
      price: 55000,
    ),
    const ProductModel(
      id: 'p_8',
      shopId: 's_6',
      categoryId: 'c_5',
      name: 'Cơm rang hải sản',
      description: 'Cơm rang cùng mực, tôm tươi ngon ngập tràn.',
      imageUrl: 'assets/images/mock/com_rang_hai_san.png',
      price: 65000,
    ),
    const ProductModel(
      id: 'p_9',
      shopId: 's_1',
      categoryId: 'c_4',
      name: 'Mì Cay Bò 7 Cấp',
      description: 'Thịt bò Mỹ mềm ngọt hòa quyện cùng nước dùng cay nồng đặc trưng.',
      imageUrl: 'assets/images/mock/mi_cay_bo.png',
      price: 59000,
    ),
    const ProductModel(
      id: 'p_10',
      shopId: 's_1',
      categoryId: 'c_4',
      name: 'Mì Cay Thập Cẩm 7 Cấp',
      description: 'Sự kết hợp hoàn hảo giữa hải sản, bò và các loại topping đặc sắc.',
      imageUrl: 'assets/images/mock/mi_cay_thap_cam.png',
      price: 69000,
    ),
    const ProductModel(
      id: 'p_11',
      shopId: 's_1',
      categoryId: 'c_4',
      name: 'Mì Cay Gà 7 Cấp',
      description: 'Thịt gà dai giòn, thấm vị cay tê tái, kích thích vị giác.',
      imageUrl: 'assets/images/mock/mi_cay_ga.png',
      price: 55000,
    ),
    const ProductModel(
      id: 'p_12',
      shopId: 's_2',
      categoryId: 'c_3',
      name: 'Trà Sữa Matcha Đậu Đỏ',
      description: 'Vị chát nhẹ của matcha hòa quyện cùng đậu đỏ bùi ngọt, thơm béo.',
      imageUrl: 'assets/images/mock/matcha_dau_do.png',
      price: 45000,
    ),
    const ProductModel(
      id: 'p_13',
      shopId: 's_2',
      categoryId: 'c_3',
      name: 'Hồng Trà Kem Cheese',
      description: 'Cốt hồng trà đậm đà lớp kem cheese mặn mặn béo ngậy tan trên đầu lưỡi.',
      imageUrl: 'assets/images/mock/hong_tra_kem_cheese.png',
      price: 38000,
    ),
    const ProductModel(
      id: 'p_14',
      shopId: 's_2',
      categoryId: 'c_3',
      name: 'Trà Đào Cam Sả',
      description: 'Thức uống giải nhiệt sảng khoái với vị đào ngọt lịm và hương sả thơm nồng.',
      imageUrl: 'assets/images/mock/tra_dao_cam_sa.png',
      price: 42000,
    ),
    const ProductModel(
      id: 'p_15',
      shopId: 's_3',
      categoryId: 'c_1',
      name: 'Phở gà tim cật',
      description: 'Phở gà truyền thống kết hợp cùng tim cật tươi ngon, bổ dưỡng.',
      imageUrl: 'assets/images/mock/pho_ga_tim_cat.png',
      price: 60000,
    ),
    const ProductModel(
      id: 'p_16',
      shopId: 's_3',
      categoryId: 'c_1',
      name: 'Phở gà măng cay',
      description: 'Vị ngọt của nước dùng gà hòa quyện cùng măng cay giòn sần sật, kích thích vị giác.',
      imageUrl: 'assets/images/mock/pho_ga_mang_cay.png',
      price: 55000,
    ),
    const ProductModel(
      id: 'p_17',
      shopId: 's_5',
      categoryId: 'c_3',
      name: 'Sinh Tố Dâu Neon',
      description: 'Dâu tây tươi rực rỡ với ánh sáng neon hồng, ngọt ngào và quyến rũ.',
      imageUrl: 'assets/images/mock/sinh_to_dau_neon.png',
      price: 48000,
    ),
    const ProductModel(
      id: 'p_18',
      shopId: 's_5',
      categoryId: 'c_3',
      name: 'Sinh Tố Xoài Cyber',
      description: 'Xoài cát chín mọng mang phong cách Cyberpunk rực rỡ sắc cam.',
      imageUrl: 'assets/images/mock/sinh_to_xoai_cyber.png',
      price: 45000,
    ),
    const ProductModel(
      id: 'p_19',
      shopId: 's_5',
      categoryId: 'c_3',
      name: 'Sinh Tố Việt Quất Galaxy',
      description: 'Hành trình vào dải ngân hà với vị việt quất đậm đà và ánh sao lung linh.',
      imageUrl: 'assets/images/mock/sinh_to_viet_quat_galaxy.png',
      price: 52000,
    ),
    const ProductModel(
      id: 'p_20',
      shopId: 's_5',
      categoryId: 'c_3',
      name: 'Sinh Tố Bơ Electric',
      description: 'Năng lượng xanh béo ngậy kết hợp cùng hiệu ứng ánh sáng điện tử mạnh mẽ.',
      imageUrl: 'assets/images/mock/sinh_to_bo_electric.png',
      price: 50000,
    ),
    const ProductModel(
      id: 'p_21',
      shopId: 's_5',
      categoryId: 'c_3',
      name: 'Sinh Tố Thanh Long Neon',
      description: 'Sắc tím đỏ rực cháy của thanh long trong màn đêm neon huyền ảo.',
      imageUrl: 'assets/images/mock/sinh_to_thanh_long_neon.png',
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
  final List<OrderModel> orders = [
    OrderModel(
      id: 'o_mock_1',
      userId: 'u_1',
      shopId: 's_6',
      shopName: 'Cơm rang Lò Đúc',
      items: const [
        OrderItemData(
          productId: 'p_6',
          productName: 'Cơm rang thập cẩm',
          productImageUrl: 'assets/images/mock/com_rang_thap_cam.png',
          price: 45000,
          quantity: 2,
        ),
      ],
      deliveryAddress: '123 Cầu Giấy, Hà Nội',
      subtotal: 90000,
      shippingFee: 15000,
      totalAmount: 105000,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];
  
  // Stream to listen to order updates
  final StreamController<List<OrderModel>> _ordersController = StreamController<List<OrderModel>>.broadcast();
  Stream<List<OrderModel>> get ordersStream => _ordersController.stream;

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
    _ordersController.add(List.from(orders));
  }

  // Helper: Remove a completed order
  void removeOrder(String orderId) {
    orders.removeWhere((o) => o.id == orderId);
    _ordersController.add(List.from(orders));
  }

  // Helper: Update order status
  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      orders[index] = orders[index].copyWith(status: status);
      _ordersController.add(List.from(orders));
    }
  }

  // Helper: Shop owner toggle product status
  void toggleProductAvailability(String productId, bool isAvailable) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      products[index] = products[index].copyWith(isAvailable: isAvailable);
    }
  }

  // Helper: Shop owner updates shop details
  void updateShop(ShopModel updatedShop) {
    final index = shops.indexWhere((s) => s.id == updatedShop.id);
    if (index >= 0) {
      shops[index] = updatedShop;
    }
  }
}
