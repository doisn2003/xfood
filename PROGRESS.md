# Xfood — Progress Tracker

## Phase 1: Foundation & Design System ✅
- Khởi tạo dự án Flutter, cấu trúc thư mục Mock Rules.
- Design System: Bảng màu Neon Mochi, Typography (Plus Jakarta Sans + Be Vietnam Pro).
- Data Models: ShopModel, ProductModel, OrderModel, VoucherModel, CategoryModel, UserModel.
- Mock Engine & Auto-Assets: Singleton MockDatabase, AI-generated images.

## Phase 2: App Layout & Core Navigation ✅
- Bottom Navigation Bar: 5 tabs (Home, Ưu Đãi, Đơn Hàng, Giỏ Hàng, Tôi).
- GoRouter StatefulShellRoute cho nested navigation.
- Nâng cấp Data Models thêm Category.

## Phase 3: Role Người Mua — Khám phá & Gamification ✅
- Home Screen: Banner Slider auto (3 banners, 5s loop), Progress Bar "Cú Đêm", Category Filter.
- Shop Detail: Cover image, Group Order button, Product list + add to cart.
- Cart & Checkout: Tab giỏ hàng, "Đi nhẹ nói khẽ", Dialog xác nhận.
- Dark Mode ép buộc cho Neon Mochi.
- Category-based filtering (product-level, không phải shop-level).
- 5 shops, 5 products, 4 categories (Bún/Phở, Mỳ, Ăn vặt, Đồ uống).

## Phase 4: Tab Ưu Đãi ✅
- **VoucherModel** nâng cấp: `isUsed`, `minOrderAmount`, `copyWith`.
- **MockDatabase** mở rộng: 6 vouchers, helpers `useVoucher()`, `addVoucher()`.
- **VoucherRepository**: CRUD qua mock layer.
- **OffersCubit**: Quản lý state tab Ưu Đãi (vouchers, products, shops).
- **OffersScreen UI**: 
  - 2 Action Cards (Voucher + Vòng Quay) cùng hàng, gradient Neon.
  - Product Grid 2 cột, giá "ảo" gạch ngang (+10%), bấm vào → Product Detail.
- **Vòng Quay May Mắn**: CustomPainter 8 ô (6 voucher + 2 "may mắn lần sau"), 
  AnimationController + easeOutCubic, weighted random (70% win), reward integration.
- **Voucher List BottomSheet**: DraggableScrollableSheet, áp dụng voucher vào Cart, trạng thái "Đã dùng".
- **Product Detail Screen**: Hero image, shop info card, quantity +/-, floating "Thêm vào giỏ" button.
- **Routing**: `/product_detail/:productId` route toàn cục (fullscreen, ngoài tab shell).
- **DI**: VoucherRepository + OffersCubit đăng ký trong main.dart.

---

### Next: Phase 5 — Tracking Map & Tương tác xã hội
- Tích hợp Google Maps/Flutter Map.
- Live Tracking: Giả lập marker shipper di chuyển.
- Share Bill Flexing.
- Lottie/Rive animations cho tất cả trạng thái.
