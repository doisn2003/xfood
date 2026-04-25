# Xfood Progress Tracker

## Completed: Phase 1 - Foundation & Design System (2026-04-25)
- **Khởi tạo dự án Flutter:** Dự án được khởi tạo thành công tại `d:\Xproject\Xfood` với tên App là `Xfood`.
- **Cài đặt thư viện:** Đã tích hợp `flutter_bloc`, `go_router`, `flutter_animate`, `lottie`.
- **Thiết lập Cấu trúc & Design System:**
  - Định nghĩa chuẩn bảng màu rực rỡ cho đồ ăn đêm (`app_colors.dart`).
  - Định nghĩa font chữ và theme chuẩn (`app_typography.dart`, `app_theme.dart`).
  - Xây dựng UI Components lõi tái sử dụng: `PrimaryButton`, `CuteTextField` có tích hợp micro-animations.
- **Tạo Data Contracts:** Định nghĩa đầy đủ Models (`UserModel`, `ShopModel`, `ProductModel`, `OrderModel`, `VoucherModel`).
- **Xây dựng Mock Engine:** Tạo hệ thống `mock_database.dart` chứa in-memory database để chia sẻ state giữa User và Shop.
- **AI Auto-Generate Assets:** AI đã tự động vẽ 5 hình ảnh chất lượng cao chuẩn aesthetic (Avatar, Quán ăn, Món ăn) lưu thẳng vào `assets/images/mock/` và mapping thành công vào `mock_database.dart`.
- **Kiểm tra (Error Checking):** Mã nguồn chạy `flutter analyze` 100% Passed. Màn hình test Design System hiển thị tốt.

---

## Completed: Phase 2 - App Layout & Core Navigation (2026-04-25)
- **Nâng cấp Data Models:** Đã tạo `CategoryModel` và tích hợp `categoryId` vào `ProductModel`, `categories` vào `ShopModel`. Cập nhật toàn bộ Mock Database theo cấu trúc mới.
- **GoRouter & Cấu trúc Điều hướng:**
  - Áp dụng `StatefulShellRoute` để tạo Bottom Navigation giữ state (không bị reload trang khi chuyển tab).
  - Tích hợp 4 tab: Home (`/home`), Ưu Đãi (`/offers`), Đơn Hàng (`/orders`), Tôi (`/profile`).
  - Đường dẫn ngoài Navbar: Giao diện chủ quán (`/shop_dashboard`).
- **Main Layout & Cupertino Icons:**
  - Xây dựng thanh `BottomNavigationBar` với giao diện bo tròn nhẹ nhàng, nổi hiệu ứng box-shadow tinh tế.
  - Sử dụng toàn bộ bộ icon của `CupertinoIcons` (Apple style) để app trông dễ thương và thân thiện hơn (vd: `house`, `ticket`, `doc_text`, `person`).
- **Giao diện Tôi (Profile):** Đã tạo một luồng chuyển đổi cực kỳ nhanh chóng bằng 1 nút bấm (PrimaryButton) bay thẳng từ app Khách hàng sang app Chủ Quán (`/shop_dashboard`).
- **Placeholder Screens:** Tạo giao diện giữ chỗ chuẩn mực cho tất cả các tab.

---

## Completed: Phase 3 - Khám phá & Trải nghiệm Gamification (Người Mua) (2026-04-25)
- **Kiến trúc Data & BLoC (Frontend-Mock Rule):**
  - Xây dựng các Repository (`shop_repository`, `product_repository`, `user_repository`, `category_repository`) mô phỏng API delay với `Future.delayed`.
  - Triển khai `HomeCubit`, `ShopDetailCubit`, và `CartCubit` để quản lý luồng dữ liệu mượt mà, tách biệt logic và UI hoàn toàn.
- **UI Trang Chủ (Home):**
  - Áp dụng triệt để Design System "Electric Marshmallow" / "Neon Mochi" (Bảng màu mới, bo góc siêu tròn, Ambient Glow).
  - Thanh tiến trình "Thử thách Cú Đêm" bắt mắt.
  - Category cuộn ngang và danh sách "Late Night Heroes" hiển thị thẻ mềm mại không đường viền.
- **UI Chi tiết quán (Shop Detail):**
  - Giao diện Header ảnh cover nổi bật.
  - Nút thêm vào giỏ hàng (`+`) mini phát sáng, tự động cập nhật số lượng xuống Bottom Modal.
- **UI Giỏ hàng (Cart):**
  - Màn hình trượt mềm mại liệt kê món ăn.
  - Tích hợp Tùy chọn "Đi nhẹ, nói khẽ" (Giao không bấm chuông).
  - Nút "Đặt món ngay" ở dạng modal bottom trượt lên với Dialog thành công dễ thương.

---

## Next Steps (Phase 4)
- Lên kế hoạch cho **Phase 4: Trải nghiệm WOW - Tracking Map & Tương tác xã hội**.
- Triển khai Map Live Tracking (Giả lập bằng Map widget với hiệu ứng lướt mượt mà của Shipper).
- Thêm các hiệu ứng Particle/Confetti (Pháo giấy) khi đơn hàng giao thành công.
