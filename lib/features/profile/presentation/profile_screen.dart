import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/core/widgets/primary_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài Khoản'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage('assets/images/mock/user_avatar.png'),
                    backgroundColor: AppColors.surfaceContainerHigh,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tôi (Cú Đêm)', style: AppTypography.h2),
                        const SizedBox(height: 4),
                        Text('0987.654.321', style: AppTypography.subtitle.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Membership & Wallet Cards
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildNeonCard(
                        context,
                        title: 'Hội viên',
                        subtitle: 'Kim Cương 💎',
                        caption: '3,450 điểm',
                        icon: Icons.workspace_premium,
                        color: AppColors.tertiary,
                        onTap: () {}, // Maybe a gamification sheet
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildNeonCard(
                        context,
                        title: 'Ví XPay',
                        subtitle: '240,000đ',
                        caption: 'Nạp thêm tiền',
                        icon: Icons.account_balance_wallet,
                        color: AppColors.primary,
                        onTap: () => _showWalletSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Text('Tiện ích của tôi', style: AppTypography.h3),
              const SizedBox(height: 16),

              // Action List
              _buildActionTile(Icons.favorite, 'Quán yêu thích', '12 quán đã lưu', onTap: () => _showFavoriteShopsSheet(context)),
              _buildActionTile(Icons.location_on, 'Sổ địa chỉ', 'Nhà, Công ty...', onTap: () => _showAddressBookSheet(context)),
              _buildActionTile(Icons.emoji_events, 'Thử thách XFood', 'Săn xu mỗi ngày', onTap: () => _showGamificationSheet(context)),
              
              const SizedBox(height: 24),
              const Text('Hỗ trợ & Hợp tác', style: AppTypography.h3),
              const SizedBox(height: 16),

              _buildActionTile(Icons.support_agent, 'Trung tâm trợ giúp', 'Chat với CSKH', onTap: () => _showChatSupportSheet(context)),
              _buildActionTile(Icons.motorcycle, 'Đăng ký Tài xế', 'Trở thành đối tác giao hàng', onTap: () => _showDriverRegistrationSheet(context)),

              const SizedBox(height: 48),
              PrimaryButton(
                text: 'Đăng Xuất',
                icon: Icons.logout,
                onPressed: () {
                  context.go('/shop_dashboard?tab=3');
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeonCard(BuildContext context, {
    required String title,
    required String subtitle,
    required String caption,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.8),
              color.withOpacity(0.3),
            ],
          ),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTypography.caption.copyWith(color: Colors.white70)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle,
                style: AppTypography.h3.copyWith(color: Colors.white),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(caption, style: AppTypography.caption.copyWith(color: Colors.white)),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
    );
  }

  Widget _buildActionTile(IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.surfaceContainerHighest),
        ),
        tileColor: AppColors.surfaceContainerHigh,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: AppTypography.subtitle),
        subtitle: Text(subtitle, style: AppTypography.caption),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }

  // --- MOCK ACTION IMPLEMENTATIONS ---

  void _showWalletSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        bool isLoading = false;
        final amountController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💳 Nạp tiền Ví XPay', style: AppTypography.h2),
                    const SizedBox(height: 8),
                    const Text('Số dư hiện tại: 540,000đ', style: AppTypography.subtitle),
                    const SizedBox(height: 24),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Nhập số tiền muốn nạp...',
                        suffixText: 'VNĐ',
                        filled: true,
                        fillColor: AppColors.surfaceContainerHigh,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      isLoading: isLoading,
                      text: 'Xác nhận Nạp',
                      icon: Icons.account_balance_wallet,
                      onPressed: () async {
                        if (amountController.text.isEmpty) return;
                        setState(() => isLoading = true);
                        await Future.delayed(const Duration(milliseconds: 1500));
                        if (context.mounted) {
                          Navigator.pop(context);
                          _showSuccessSnackBar(context, 'Đã nạp thành công ${amountController.text}đ vào Ví XPay!');
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFavoriteShopsSheet(BuildContext context) {
    final shops = [
      {'name': 'Cơm rang Lò Đúc', 'rating': '4.8', 'address': '127 Lò Đúc'},
      {'name': 'Trà sữa MIXUE', 'rating': '4.5', 'address': 'Bách Khoa'},
      {'name': 'Bún chả Sinh Từ', 'rating': '4.9', 'address': 'Tạ Quang Bửu'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💖 Quán Yêu Thích', style: AppTypography.h2),
                const SizedBox(height: 16),
                ...shops.map((s) {
                  bool isRemoved = false;
                  bool isLoading = false;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      if (isRemoved) return const SizedBox();
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.store, color: AppColors.textSecondary),
                        ),
                        title: Text(s['name']!, style: AppTypography.subtitle),
                        subtitle: Text('⭐ ${s['rating']} • ${s['address']}', style: AppTypography.caption),
                        trailing: IconButton(
                          icon: isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                            : const Icon(Icons.favorite, color: AppColors.primary),
                          onPressed: isLoading ? null : () async {
                            setState(() => isLoading = true);
                            await Future.delayed(const Duration(milliseconds: 800));
                            if (context.mounted) {
                              setState(() => isRemoved = true);
                            }
                          },
                        ),
                      );
                    }
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddressBookSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        bool isLoading = false;
        final addressController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📍 Sổ Địa Chỉ', style: AppTypography.h2),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.home, color: AppColors.primary),
                      title: const Text('Nhà riêng', style: AppTypography.subtitle),
                      subtitle: const Text('Số 1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội', style: AppTypography.caption),
                      trailing: const Icon(Icons.edit, size: 16, color: AppColors.textSecondary),
                    ),
                    ListTile(
                      leading: const Icon(Icons.work, color: AppColors.tertiary),
                      title: const Text('Công ty', style: AppTypography.subtitle),
                      subtitle: const Text('Tòa nhà C9, Đại học Bách Khoa', style: AppTypography.caption),
                      trailing: const Icon(Icons.edit, size: 16, color: AppColors.textSecondary),
                    ),
                    const Divider(color: AppColors.surfaceContainerHighest, height: 32),
                    const Text('Thêm địa chỉ mới', style: AppTypography.h3),
                    const SizedBox(height: 16),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: 'Nhập địa chỉ...',
                        filled: true,
                        fillColor: AppColors.surfaceContainerHigh,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      isLoading: isLoading,
                      text: 'Lưu Địa Chỉ',
                      icon: Icons.save,
                      onPressed: () async {
                        if (addressController.text.isEmpty) return;
                        setState(() => isLoading = true);
                        await Future.delayed(const Duration(milliseconds: 1500));
                        if (context.mounted) {
                          Navigator.pop(context);
                          _showSuccessSnackBar(context, 'Đã lưu địa chỉ mới thành công!');
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showGamificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🏆 Thử Thách Tuần', style: AppTypography.h2),
                    const SizedBox(height: 8),
                    const Text('Hoàn thành các mốc để nhận phần thưởng hấp dẫn.', style: AppTypography.caption),
                    const SizedBox(height: 24),
                    const Text('Tiến độ: 2/3 Đơn hàng', style: AppTypography.h3),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.66,
                      backgroundColor: AppColors.surfaceContainerHighest,
                      color: AppColors.primary,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      isLoading: isLoading,
                      text: 'Nhận Thưởng Ngay',
                      icon: Icons.card_giftcard,
                      onPressed: () async {
                        setState(() => isLoading = true);
                        await Future.delayed(const Duration(milliseconds: 1000));
                        if (context.mounted) {
                          setState(() => isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Chưa đủ điều kiện! Cần thêm 1 đơn hàng nữa.'),
                              backgroundColor: AppColors.error,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showChatSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        bool isLoading = false;
        final chatController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💬 Trung tâm Trợ Giúp', style: AppTypography.h2),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.support_agent, size: 40, color: AppColors.primary),
                          SizedBox(width: 16),
                          Expanded(child: Text('Xin chào! Tôi có thể giúp gì cho bạn hôm nay?', style: AppTypography.body)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: chatController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Nhập vấn đề của bạn...',
                        filled: true,
                        fillColor: AppColors.surfaceContainerHigh,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      isLoading: isLoading,
                      text: 'Gửi Hỗ Trợ',
                      icon: Icons.send,
                      onPressed: () async {
                        if (chatController.text.isEmpty) return;
                        setState(() => isLoading = true);
                        await Future.delayed(const Duration(milliseconds: 1500));
                        if (context.mounted) {
                          Navigator.pop(context);
                          _showSuccessSnackBar(context, 'Đã gửi yêu cầu! CSKH sẽ phản hồi trong 2 phút.');
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDriverRegistrationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        bool isLoading = false;
        final nameController = TextEditingController();
        final plateController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🛵 Đăng ký Tài xế XFood', style: AppTypography.h2),
                    const SizedBox(height: 8),
                    const Text('Gia nhập đội ngũ giao hàng và kiếm thêm thu nhập.', style: AppTypography.caption),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Họ và tên',
                        filled: true,
                        fillColor: AppColors.surfaceContainerHigh,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: plateController,
                      decoration: InputDecoration(
                        labelText: 'Biển số xe',
                        filled: true,
                        fillColor: AppColors.surfaceContainerHigh,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      isLoading: isLoading,
                      text: 'Nộp Đơn Đăng Ký',
                      icon: Icons.app_registration,
                      onPressed: () async {
                        if (nameController.text.isEmpty || plateController.text.isEmpty) return;
                        setState(() => isLoading = true);
                        await Future.delayed(const Duration(milliseconds: 2000));
                        if (context.mounted) {
                          Navigator.pop(context);
                          _showSuccessSnackBar(context, 'Nộp đơn thành công! Hệ thống sẽ liên hệ bạn sớm nhất.');
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
