# Xfood - Kế hoạch triển khai & Kiến trúc

Dự án Xfood - Ứng dụng đặt đồ ăn trực tuyến với định hướng tập trung vào thị trường "đồ ăn đêm". Mục tiêu của phiên bản này là **Demo Gọi Vốn (Pitching)** cho nhà đầu tư, do đó ưu tiên tối đa vào giao diện (UI) tuyệt đẹp, trải nghiệm người dùng (UX) mượt mà, hiệu ứng "wow", sử dụng kiến trúc Mock Data (không cần Backend) nhưng vẫn đảm bảo tính mở rộng cho tương lai.

---

## 1. Phân tích nghiệp vụ (Business Analysis)

### 1.1. Mục tiêu & Định hướng thiết kế
- **Tập trung:** Đồ ăn đêm.
- **Phong cách thiết kế:** Dễ thương (cute), màu sắc rực rỡ/nổi bật kích thích vị giác (như cam, đỏ, vàng), icon thân thiện. Hình ảnh món ăn to, rõ nét, chất lượng cao.
- **Trải nghiệm:** Micro-animations (hiệu ứng khi bấm, thả tim), Haptic feedback (rung nhẹ khi thao tác), transition mượt mà giữa các trang.

### 1.2. Phân tích Role & Chức năng cốt lõi (Bổ sung tính năng sáng tạo)

**A. Role Người Mua (User - Khách hàng)**
1. **Khám phá & Tìm kiếm (Gamification):**
   - Trang chủ hiển thị: Banner khuyến mãi, Danh mục (Ăn vặt, Bún phở, Trà sữa...), Danh sách quán đang mở cửa.
   - Tìm kiếm và bộ lọc (Gần đây, Đánh giá cao, Khuyến mãi).
   - **[Mock] Vòng quay may mắn (Midnight Roulette):** Tính năng Gamification, người dùng không biết ăn gì có thể "quay" để app chọn ngẫu nhiên 1 quán kèm mã giảm giá nhỏ, tạo cảm giác thú vị khi thức khuya.
   - **[Mock] Thử thách "Cú Đêm":** Tích điểm khi đặt đồ ăn sau 11h đêm để đổi quà (kèm hiệu ứng tung hoa, chúc mừng).
2. **Đặt đồ ăn & Thanh toán:**
   - Xem chi tiết quán và Menu món ăn.
   - **[Mock] Đặt chung (Group Order):** Giao diện chia sẻ link mời bạn bè cùng chọn món vào chung 1 giỏ hàng (giả lập avatar người khác đang chọn món realtime).
   - Chọn món, tùy chỉnh (Topping, Size, Ghi chú).
   - Giỏ hàng & Áp Voucher (Freeship, Giảm giá).
   - Checkout với các phương thức thanh toán giả lập.
   - **[Mock] Hẹn giờ giao:** Cho phép khách chọn giờ giao đồ ăn khuya trong tương lai.
3. **Theo dõi đơn hàng & Social:**
   - Xem vị trí shipper di chuyển **trực tiếp trên bản đồ** (Animation mô phỏng).
   - Cập nhật trạng thái đơn hàng (Đã nhận -> Đang chuẩn bị -> Đang giao).
   - **[Mock] Chia sẻ Bill Flexing:** Sau khi đặt xong, cung cấp template hóa đơn dễ thương để share lên Instagram Story / Facebook.

**B. Role Chủ Quán (Shop Owner)**
1. **Quản lý cửa hàng & Marketing:**
   - Thiết lập thông tin: Tên, địa chỉ, giờ mở/đóng cửa.
   - **Giao hàng tự túc:** Thiết lập công thức tính phí ship (Đồng giá 15k, hoặc 5k/1km).
   - **[Mock] Flash Sale Đêm Khuya:** Tính năng cài đặt giảm giá tự động trong khung giờ vàng (VD: 12h - 2h sáng).
   - **[Mock] Broadcast "Thả thính":** Tính năng mô phỏng gửi Push Notification hàng loạt cho khách cũ (VD: "Đói bụng chưa? Cháo sườn đang nóng hổi...").
2. **Quản lý Thực đơn (Interactive Menu):**
   - Đăng tải món ăn theo danh mục.
   - Quản lý trạng thái (Còn/Hết món).
   - **[Mock] Kho ảo (Auto Out-of-Stock):** Thiết lập số lượng tồn kho ảo, bán hết số lượng app tự động báo hết món.
   - **[Mock] Video/Story Món ăn:** Chủ quán upload video ngắn (kiểu TikTok/Story) cảnh đang nấu ăn xèo xèo để gắn vào món ăn, kích thích khách hàng.
3. **Quản lý Đơn hàng & Thống kê nâng cao:**
   - Nhận đơn hàng mới (Kèm âm thanh thông báo "Ting ting" liên tục).
   - **[Mock] Chế độ "Quá tải" (Bận rộn):** Nút gạt tự động cộng thêm 15-30p vào thời gian giao hàng dự kiến để khách hàng biết quán đang đông.
   - Thay đổi trạng thái đơn (Xác nhận -> Hoàn thành).
   - **[Mock] Analytics Insight:** Dashboard phân tích món nào bán chạy nhất vào khung giờ nào, Heatmap khu vực khách đặt nhiều nhất (bản đồ nhiệt giả lập).

---

## 2. Kiến trúc triển khai (Deployment Architecture)

Tuân thủ nghiêm ngặt rule `frontend-mock.md`: Tách biệt hoàn toàn UI và Data. Ứng dụng phải hoạt động trơn tru với dữ liệu giả lập (Mock) với độ trễ (delay) như API thật, đồng thời sẵn sàng chuyển đổi sang API thật sau này mà không cần đụng vào UI.

### 2.1. Technology Stack
- **Framework:** Flutter.
- **State Management:** BLoC cho việc tách biệt Business Logic.
- **Routing:** GoRouter (hỗ trợ deep link và nested routing tốt).
- **Map:** Google Maps Flutter / Flutter Map (kết hợp dữ liệu GPS giả lập).
- **UI/Animations:** `flutter_animate`, `lottie` (cho các icon/trạng thái trống).

### 2.2. Abstract Architecture (Theo Rule Mock Data)
Cấu trúc thư mục được chia theo Features (Tính năng) kết hợp với Layered Architecture:

```text
lib/
├── core/                   # Theme, Utils, Constants, Base Classes
├── data_sources/           # Nơi quyết định lấy data từ Mock hay Real API
│   ├── env.dart            # Chứa biến USE_MOCK = true
│   └── mock_server/        # Nơi chứa toàn bộ Mock Data tĩnh và logic delay
├── features/
│   ├── auth/
│   ├── user_home/
│   ├── user_order/
│   ├── shop_dashboard/
│   └── ...
│       ├── models/         # Schema dữ liệu (Data Contracts - dùng chung cho Mock và API sau này)
│       ├── repositories/   # Interface và Implementation cho việc truy xuất data
│       ├── services/       # Business logic / Usecases
│       └── presentation/   # UI Layer (Screens, Widgets). TUYỆT ĐỐI không chứa logic data.
└── main.dart
```

### 2.3. Quy tắc cốt lõi áp dụng cho dự án
1. **Data Contract First:** Mọi Models (`User`, `Shop`, `Product`, `Order`) phải được định nghĩa chuẩn xác như thể đang có Backend.
2. **Artificial Delay & States:** Mọi thao tác lấy dữ liệu/submit phải qua Repository, có `Future.delayed(Duration(milliseconds: 800))` để UI hiển thị đủ các trạng thái `Loading`, `Success`, `Error`.
3. **Centralized Mock Storage:** Dùng In-memory state (như một class Singleton hoặc Riverpod provider) lưu trữ danh sách Order, User để khi User đặt hàng, Role Shop có thể thấy đơn hàng mới xuất hiện.
4. **Automated Local Assets:** AI Assistant (Antigravity) sẽ sử dụng công cụ nội bộ (`generate_image`) để tự động sinh ra hàng loạt ảnh món ăn đêm cực nét, màu sắc vibrant, nén định dạng `.webp` và lưu trực tiếp vào source code. Không yêu cầu User phải tải thủ công.

---

## 3. Lộ trình triển khai (Implementation Phases)

Để đảm bảo tiến độ và ra mắt được bản Demo ấn tượng nhất, dự án chia làm 5 Phase.

### Phase 1: Foundation & Design System (Thiết lập nền tảng)
*Tập trung xây dựng bộ móng kiến trúc vững chắc và hệ thống UI chuẩn.*
- Khởi tạo dự án Flutter, thiết lập cấu trúc thư mục chuẩn theo Mock Rules.
- Xây dựng **Design System**: Định nghĩa bảng màu (màu ấm, rực rỡ), Typography dễ thương, tạo các Custom Components (Buttons, TextFields, Cards).
- Định nghĩa toàn bộ **Data Models** (`ShopModel`, `ProductModel`, `OrderModel`).
- Xây dựng **Mock Engine & Auto-Assets**: Hệ thống giả lập Database In-memory. Đồng thời, AI sẽ kích hoạt quy trình tự động sinh toàn bộ hình ảnh đồ ăn (AI Image Generation) và tự động đóng gói vào thư mục `assets`.

### Phase 2: App Layout & Core Navigation (Xây dựng Bố cục & Điều hướng)
*Thiết lập khung sườn Navigation và nâng cấp cấu trúc Dữ liệu để phục vụ việc mở rộng.*
- Nâng cấp **Data Models**: Bổ sung thêm field Category (Danh mục) vào dữ liệu món ăn/quán ăn và cập nhật Mock Database.
- Xây dựng **Main Bottom Navigation Bar** với 4 Tabs chính:
  - **Home**: Trang chủ trưng bày đồ ăn đêm, danh mục nổi bật.
  - **Ưu Đãi**: Hiển thị danh sách Voucher và tích hợp Mini-game "Vòng quay may mắn".
  - **Đơn Hàng**: Nơi quản lý danh sách đơn hàng và xem Tracking Map.
  - **Tôi**: Trang cá nhân, thiết lập Affiliates, và có logic Render giao diện động tùy theo Role (User / Shop).
- Khởi tạo các Route cơ bản bằng `go_router` cho 4 tab này.

### Phase 3: Role Người Mua - Khám phá & Trải nghiệm Gamification
*Tạo ra trải nghiệm đặt hàng "mượt như lụa" kết hợp Gamification để giữ chân khách thức khuya.*
- Xây dựng Mock Data cho danh sách quán, menu hấp dẫn (hình ảnh/video món ăn chất lượng cao).
- **UI Trang chủ (Home):** Banner slider động, hiển thị thanh tiến trình "Thử thách Cú Đêm".
- **UI Chi tiết quán:** Hiển thị Menu (hỗ trợ dạng video story), UI chia sẻ "Group Order".
- **UI Giỏ hàng & Thanh toán:** Flow chọn voucher, chọn tùy chọn "Đi nhẹ nói khẽ", tính tổng tiền và thao tác checkout. Tích hợp màn hình Loading mô phỏng.

### Phase 4: Trải nghiệm WOW - Tracking Map & Tương tác xã hội
*Điểm nhấn để thuyết phục nhà đầu tư (Pitching Killer Feature).*
- Tích hợp Bản đồ (Google Maps/Mapbox) vào tab Đơn Hàng.
- Xây dựng luồng **Live Tracking**: Vẽ lộ trình tuyến đường, giả lập marker shipper di chuyển mượt mà trên bản đồ.
- Phát triển UI "Share Bill Flexing" đẹp mắt sau khi đặt hàng thành công.
- Áp dụng các hiệu ứng animation (Lottie, Rive) cho mọi tương tác: Thành công, Rỗng (Empty State), pháo hoa khi hoàn thành "Thử thách Cú Đêm".

### Phase 5: Role Chủ Quán & Đóng gói
*Hoàn thiện bộ công cụ quản lý và Marketing cho Shop, Polish toàn bộ dự án.*
- **UI Dashboard Shop:** Thống kê doanh thu, biểu đồ "Insight khung giờ", bản đồ nhiệt (Heatmap) giả lập.
- **UI Quản lý đơn:** Nhận đơn realtime, UI bật/tắt "Chế độ Quá tải".
- **UI Marketing:** Giao diện thiết lập "Flash Sale Đêm Khuya" và gửi Push Notification "Thả thính" khách cũ.
- Rà soát toàn bộ app, tối ưu hiệu năng animation, đảm bảo không có lỗi vặt.
- Xuất bản file APK / iOS TestFlight để đi Pitching.
