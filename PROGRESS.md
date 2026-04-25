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

## Next Steps (Phase 3)
- Lên kế hoạch cho **Phase 3: Khám phá & Trải nghiệm Gamification (Cho Role Người Mua)**.
- Xây dựng Widget "Vòng quay may mắn" (Gamification).
- Hoàn thiện giao diện Trang chủ (`HomeScreen`) với Banner Slider, Danh mục ngang (Categories Horizontal List), và Danh sách quán ăn.
- Thiết kế giao diện Chi tiết quán ăn, phân loại món ăn, và làm UI giỏ hàng Mini thả nổi.
