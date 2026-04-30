import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/core/widgets/primary_button.dart';
import 'package:xfood/features/shop_dashboard/presentation/bloc/shop_cubit.dart';
import 'package:xfood/features/shared/models/product_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShopProfileTab extends StatelessWidget {
  const ShopProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt Quán'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<ShopCubit, ShopState>(
          builder: (context, state) {
            if (state.status == ShopStatus.loading || state.shopInfo == null) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            final shop = state.shopInfo!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        shop.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 100, height: 100, color: Colors.grey,
                          child: const Icon(Icons.store, size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(child: Text(shop.name, style: AppTypography.h2)),
                  Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(shop.address, style: AppTypography.caption),
                    ],
                  )),
                  const SizedBox(height: 32),
                  
                  // Status Toggle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceContainerHighest),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(shop.isOpen ? 'Đang mở cửa' : 'Đã đóng cửa', style: AppTypography.h3),
                        Switch(
                          value: shop.isOpen,
                          activeColor: AppColors.success,
                          onChanged: (val) {
                            context.read<ShopCubit>().updateShopStatus(val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Công cụ & Tiện ích', style: AppTypography.h3),
                  const SizedBox(height: 16),

                  // Mock Features
                  _buildListTile(Icons.flash_on, 'Flash Sale Đêm Khuya', 'Khuyến mãi giờ vàng', onTap: () => _showFlashSaleSheet(context, state.products)),
                  _buildListTile(Icons.campaign, 'Chiến dịch Marketing', 'Gửi tin nhắn hàng loạt', onTap: () => _showMarketingSheet(context)),
                  _buildListTile(Icons.motorcycle, 'Danh sách Shipper túc trực', 'Tuyển tài xế quanh đây', onTap: () => _showShipperListSheet(context)),
                  _buildListTile(Icons.map, 'Cài đặt vị trí GPS', 'Chỉnh sửa tọa độ bản đồ', onTap: () => _showLocationDialog(context, shop.address)),
                  _buildListTile(Icons.notifications, 'Cài đặt thông báo', 'Tùy chỉnh hệ thống', onTap: () => _showNotificationSettingsSheet(context)),

                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Đăng Xuất',
                    icon: Icons.logout,
                    onPressed: () {
                      context.go('/profile');
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
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

  void _showFlashSaleSheet(BuildContext context, List<ProductModel> products) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        bool isLoading = false;
        double discount = 20;
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⚡ Flash Sale Đêm Khuya', style: AppTypography.h2),
                    const SizedBox(height: 8),
                    const Text('Chọn mức giảm giá và áp dụng cho các món ăn để thu hút khách săn sale.', style: AppTypography.caption),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mức giảm:', style: AppTypography.h3),
                        Text('${discount.toInt()}%', style: AppTypography.h2.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    Slider(
                      value: discount,
                      min: 5,
                      max: 50,
                      divisions: 9,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => discount = val),
                    ),
                    const SizedBox(height: 16),
                    const Text('Áp dụng cho:', style: AppTypography.subtitle),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            value: true,
                            onChanged: (v) {},
                            title: Text(products[index].name, style: AppTypography.body),
                            activeColor: AppColors.primary,
                            checkColor: AppColors.textDark,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      isLoading: isLoading,
                      text: 'Kích hoạt Flash Sale',
                      icon: Icons.bolt,
                      onPressed: () async {
                        setState(() => isLoading = true);
                        await Future.delayed(const Duration(milliseconds: 1500));
                        if (context.mounted) {
                          Navigator.pop(context);
                          _showSuccessSnackBar(context, 'Đã kích hoạt Flash Sale ${discount.toInt()}% thành công!');
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

  void _showShipperListSheet(BuildContext context) {
    final shippers = [
      {'name': 'Nguyễn Văn A', 'distance': '0.2km', 'plate': '29F1-123.45'},
      {'name': 'Trần Thị B', 'distance': '0.5km', 'plate': '30G2-987.65'},
      {'name': 'Lê Văn C', 'distance': '1.1km', 'plate': '29A1-111.22'},
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
                const Text('🛵 Tài xế đang túc trực', style: AppTypography.h2),
                const SizedBox(height: 8),
                const Text('Mời tài xế nhận đơn trước để giao hàng nhanh hơn.', style: AppTypography.caption),
                const SizedBox(height: 16),
                ...shippers.map((s) {
                  bool isInvited = false;
                  bool isLoading = false;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.surfaceContainerHighest,
                          child: const Icon(Icons.person, color: AppColors.textSecondary),
                        ),
                        title: Text(s['name']!, style: AppTypography.subtitle),
                        subtitle: Text('${s['distance']} • ${s['plate']}', style: AppTypography.caption),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isInvited ? AppColors.success : AppColors.primary,
                            foregroundColor: isInvited ? Colors.white : AppColors.textDark,
                          ),
                          onPressed: (isInvited || isLoading) ? null : () async {
                            setState(() => isLoading = true);
                            await Future.delayed(const Duration(milliseconds: 1000));
                            if (context.mounted) {
                              setState(() {
                                isLoading = false;
                                isInvited = true;
                              });
                            }
                          },
                          child: isLoading 
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textDark))
                            : Text(isInvited ? 'Đã mời' : 'Mời gọi'),
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

  void _showMarketingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📢 Gửi tin nhắn Marketing', style: AppTypography.h2),
                    const SizedBox(height: 8),
                    const Text('Gửi thông báo đẩy (Push Notification) tới 369 khách hàng cũ của quán.', style: AppTypography.caption),
                    const SizedBox(height: 24),
                    TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Nhập nội dung tin nhắn (VD: Giảm 30% cho khách cũ hôm nay)...',
                        filled: true,
                        fillColor: AppColors.surfaceContainerHigh,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      isLoading: isLoading,
                      text: 'Gửi tin nhắn',
                      icon: Icons.send,
                      onPressed: () async {
                        setState(() => isLoading = true);
                        await Future.delayed(const Duration(milliseconds: 2000));
                        if (context.mounted) {
                          Navigator.pop(context);
                          _showSuccessSnackBar(context, 'Đã gửi tin nhắn tới 369 khách hàng!');
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

  void _showLocationDialog(BuildContext context, String currentAddress) {
    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: AlertDialog(
                backgroundColor: AppColors.surfaceContainerLow,
                title: const Text('Cài đặt GPS', style: AppTypography.h2),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.map, size: 64, color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: TextEditingController(text: currentAddress),
                      decoration: InputDecoration(
                        labelText: 'Địa chỉ cụ thể',
                        filled: true,
                        fillColor: AppColors.surfaceContainerHigh,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textDark),
                    onPressed: isLoading ? null : () async {
                      setState(() => isLoading = true);
                      await Future.delayed(const Duration(milliseconds: 1500));
                      if (context.mounted) {
                        Navigator.pop(context);
                        _showSuccessSnackBar(context, 'Đã cập nhật vị trí quán trên bản đồ!');
                      }
                    },
                    child: isLoading 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textDark))
                      : const Text('Lưu Tọa Độ'),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

  void _showNotificationSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        bool notif1 = true;
        bool notif2 = true;
        bool notif3 = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🔔 Cài đặt thông báo', style: AppTypography.h2),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Báo chuông khi có đơn mới', style: AppTypography.body),
                      activeColor: AppColors.primary,
                      value: notif1,
                      onChanged: (v) => setState(() => notif1 = v),
                    ),
                    SwitchListTile(
                      title: const Text('Tin nhắn từ khách hàng', style: AppTypography.body),
                      activeColor: AppColors.primary,
                      value: notif2,
                      onChanged: (v) => setState(() => notif2 = v),
                    ),
                    SwitchListTile(
                      title: const Text('Tin nhắn hệ thống / Khuyến mãi', style: AppTypography.body),
                      activeColor: AppColors.primary,
                      value: notif3,
                      onChanged: (v) => setState(() => notif3 = v),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }
        );
      }
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
