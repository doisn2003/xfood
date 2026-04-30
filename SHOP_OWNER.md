# Xfood - Tài Liệu Kiến Trúc & Kế Hoạch Triển Khai (Role: Chủ Quán)

## 1. Phân Tích Nghiệp Vụ (Business Logic)

Vai trò **Chủ Quán (Shop Owner)** trong Xfood (thuộc Phase 6) cung cấp đầy đủ các công cụ quản lý đơn hàng, doanh thu và sản phẩm. Điểm nhấn là khả năng đồng bộ trạng thái đơn hàng theo thời gian thực (real-time mockup) với ứng dụng của khách hàng nhờ vào cơ chế In-Memory Mock Database.

### 1.1. Cấu trúc Navigation Bar (Điều hướng chính)
App của chủ quán sẽ có một Bottom Navigation Bar riêng biệt gồm 4 tab:
1. **Home (Trang chủ - Xử lý đơn hàng):**
   - Nhận đơn hàng mới theo thời gian thực (đồng bộ với khách đặt).
   - Hiển thị danh sách đơn hàng theo trạng thái: Đang chờ xác nhận, Đang chuẩn bị, Đang giao, Đã hoàn thành.
   - Thao tác: Xác nhận đơn, Hủy đơn, Đánh dấu đang chuẩn bị, Đánh dấu đang giao, Đánh dấu hoàn thành.
   - Hiệu ứng âm thanh và Push Notification (Mock) khi có đơn mới.
2. **Quán (Quản lý cửa hàng & Sản phẩm):**
   - Thiết lập thông tin quán: Tên quán, giờ mở cửa/đóng cửa, ảnh bìa.
   - Quản lý sản phẩm (CRUD): Thêm món mới, sửa giá, xóa món.
   - Tính năng Bật/Tắt nhanh: Gạt toggle để chuyển món thành trạng thái "Đang bán" hoặc "Hết hàng".
3. **Doanh thu (Thống kê):**
   - Hiển thị tổng doanh thu trong ngày, tuần, tháng.
   - Lịch sử đơn hàng chi tiết đã hoàn thành.
   - Biểu đồ thống kê (Bar/Line chart mock) và Insight khung giờ vàng (giờ nào bán chạy nhất).
4. **Tôi (Thiết lập cá nhân):**
   - Thông tin cá nhân chủ quán.
   - Cài đặt ứng dụng (Ngôn ngữ, Âm báo).
   - Đăng xuất / Chuyển đổi role (Mock).

### 1.2. Tính năng Đồng Bộ Đơn Hàng (Order Synchronization)
- Khách hàng (User) đặt đơn -> Dữ liệu được ghi vào `MockDatabase.instance.orders`.
- App Chủ quán (Shop Owner) liên tục lắng nghe hoặc fetch lại từ `MockDatabase` (hoặc thông qua Stream Controller giả lập) để thấy đơn mới xuất hiện.
- Chủ quán cập nhật trạng thái đơn (VD: Từ `pending` -> `preparing`) -> Khách hàng thấy trạng thái đơn hàng của mình thay đổi trên Tracking Map.

---

## 2. Kiến Trúc Hệ Thống (Tuân thủ rule frontend-mock.md)

Tuân thủ nguyên tắc: **Tách biệt hoàn toàn UI và Data**.

### 2.1. Lớp Dữ Liệu (Data Layer)
Sử dụng chung `MockDatabase` trong `lib/data_sources/mock_server/mock_database.dart` để chia sẻ trạng thái.
- **Thêm Stream/Notifier cho Đơn hàng:** Để mô phỏng realtime, ta có thể kết hợp `MockDatabase` với `StreamController` hoặc sử dụng `setInterval` polling mock data.

### 2.2. Models & Entities
Sử dụng chung các model ở `lib/features/shared/models/`:
- `OrderModel`: Đã có, cần đảm bảo trạng thái (status) đầy đủ (`pending`, `preparing`, `delivering`, `completed`, `cancelled`).
- `ProductModel`: Quản lý `isAvailable` để bật/tắt món.
- `ShopModel`: Quản lý thông tin giờ mở cửa (`openingHours`).

### 2.3. Lớp Repository (Domain/Data Access)
Tạo thư mục `lib/features/shop_owner/repositories/`:
- `ShopOrderRepository`: `getOrders()`, `updateOrderStatus()`.
- `ShopProductRepository`: `getShopProducts()`, `addProduct()`, `updateProduct()`, `toggleProductStatus()`.
- `ShopInfoRepository`: `getShopInfo()`, `updateShopInfo()`.

### 2.4. Lớp Business Logic (Bloc / Service)
Tạo thư mục `lib/features/shop_owner/presentation/bloc/`:
- `ShopOrderBloc`: Quản lý state danh sách đơn hàng và trạng thái cập nhật đơn.
- `ShopProductBloc`: Quản lý state danh sách sản phẩm của quán.
- `ShopDashboardBloc`: Quản lý dữ liệu doanh thu.

### 2.5. Lớp Giao Diện (Presentation - UI)
Tạo thư mục `lib/features/shop_owner/presentation/screens/`:
- `shop_main_layout.dart`: Scaffold chứa BottomNavigationBar.
- `shop_home_screen.dart`: Tab Home (Đơn hàng).
- `shop_products_screen.dart`: Tab Quán (Quản lý món).
- `shop_revenue_screen.dart`: Tab Doanh thu.
- `shop_profile_screen.dart`: Tab Tôi.

---

## 3. Kế Hoạch Triển Khai (Coding Plan)

### Bước 1: Setup Core & Navigation cho Role Chủ Quán
- Thêm cơ chế chuyển đổi Role (User <-> Shop Owner). Tạm thời gán hardcode `isShopOwner = true` để làm UI cho chủ quán.
- Xây dựng file `shop_main_layout.dart` với 4 tab.
- Cấu hình Router (GoRouter) để có thể truy cập `/shop`.

### Bước 2: Nâng cấp Mock Database hỗ trợ Realtime
- Bổ sung `StreamController<List<OrderModel>>` vào `MockDatabase` để UI có thể lắng nghe sự thay đổi khi có đơn hàng mới (hoặc dùng Bloc polling định kỳ).
- Mock sẵn một vài `OrderModel` đang chờ xử lý vào `MockDatabase` để có dữ liệu test.

### Bước 3: Phát triển Tab Home (Quản lý đơn hàng)
- Xây dựng `ShopOrderRepository` để lấy danh sách đơn của 1 shop (VD: Shop ID = `s_6` - Cơm rang Lò Đúc).
- Build UI `shop_home_screen.dart` hiển thị danh sách dạng Card (Mã đơn, Tên khách, Món ăn, Tổng tiền).
- Nút Action: "Xác nhận", "Hoàn thành". Khi bấm sẽ trigger Repository để đổi state trong `MockDatabase`.

### Bước 4: Phát triển Tab Quán (Quản lý sản phẩm)
- Xây dựng `ShopProductRepository`.
- Build UI `shop_products_screen.dart` liệt kê các sản phẩm của `s_6`.
- Cài đặt Switch/Toggle cho phép đổi thuộc tính `isAvailable` (cần bổ sung field này vào `ProductModel` nếu chưa có).
- Tạo popup Modal Bottom Sheet để sửa nhanh giá sản phẩm.

### Bước 5: Phát triển Tab Doanh thu & Tôi
- Mock hàm `getRevenueSummary()` tính tổng tiền các đơn `completed` trong `MockDatabase`.
- Build UI dạng biểu đồ đơn giản hoặc các chỉ số (Tổng đơn, Tổng doanh thu).
- Xây dựng UI thông tin cá nhân.

### Bước 6: Ghép nối & Kiểm thử Đồng bộ (Sync Test)
- Đứng ở role Khách, đặt một đơn.
- Chuyển sang role Chủ quán, kiểm tra xem đơn có hiển thị ở Tab Home không.
- Đổi trạng thái đơn ở Chủ quán thành "Đang giao".
- Quay lại role Khách kiểm tra trạng thái đơn.
