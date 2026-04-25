import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/core/widgets/primary_button.dart';
import 'package:xfood/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:xfood/features/cart/presentation/bloc/checkout_cubit.dart';
import 'package:xfood/features/cart/presentation/widgets/voucher_picker_sheet.dart';

/// Danh sách quận Hà Nội (Mock — không cần internet)
const List<String> _hanoiDistricts = [
  'Ba Đình',
  'Hoàn Kiếm',
  'Hai Bà Trưng',
  'Đống Đa',
  'Tây Hồ',
  'Cầu Giấy',
  'Thanh Xuân',
  'Hoàng Mai',
  'Long Biên',
  'Nam Từ Liêm',
  'Bắc Từ Liêm',
  'Hà Đông',
  'Thanh Trì',
  'Gia Lâm',
  'Đông Anh',
];

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return '${buffer}đ';
  }

  void _showDistrictPicker(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Chọn Quận/Huyện', style: AppTypography.h3.copyWith(color: AppColors.primary)),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              itemCount: _hanoiDistricts.length,
              itemBuilder: (_, index) {
                final district = _hanoiDistricts[index];
                final isSelected = cartCubit.state.selectedDistrict == district;
                return GestureDetector(
                  onTap: () {
                    cartCubit.setDistrict(district);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            district,
                            style: AppTypography.subtitle.copyWith(
                              color: isSelected ? AppColors.primary : null,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(CupertinoIcons.checkmark_alt_circle_fill,
                            color: AppColors.primary, size: 22),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showVoucherPicker(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final state = cartCubit.state;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        builder: (_, scrollController) => VoucherPickerSheet(
          currentSubtotal: state.subtotal,
          currentVoucher: state.selectedVoucher,
          onSelected: (voucher) {
            if (voucher == null) {
              cartCubit.removeVoucher();
            } else {
              cartCubit.applyVoucher(voucher);
            }
          },
        ),
      ),
    );
  }

  void _handlePlaceOrder(BuildContext context) {
    final cartState = context.read<CartCubit>().state;

    // Sync address from controller
    context.read<CartCubit>().setDeliveryAddress(_addressController.text);

    // Validate address
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng nhập số nhà & tên đường', style: TextStyle(color: AppColors.textDark)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
      );
      return;
    }
    if (cartState.selectedDistrict.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng chọn Quận/Huyện', style: TextStyle(color: AppColors.textDark)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
      );
      return;
    }

    // Updated state after sync
    final updatedState = context.read<CartCubit>().state;
    context.read<CheckoutCubit>().placeOrder(updatedState);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, checkoutState) {
        if (checkoutState is CheckoutSuccess) {
          _showSuccessDialog(context, checkoutState);
        } else if (checkoutState is CheckoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(checkoutState.message, style: const TextStyle(color: AppColors.textDark)),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Giỏ hàng của bạn'),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.cart, size: 80, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text('Giỏ hàng đang trống', style: AppTypography.subtitle),
                    const SizedBox(height: 8),
                    Text('Hãy chọn vài món ăn đêm nhé!', style: AppTypography.bodySecondary),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // ─── 1. Danh sách sản phẩm ───
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = state.items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  item.product.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 80,
                                    height: 80,
                                    color: AppColors.surfaceContainerHighest,
                                    child: const Icon(Icons.fastfood, color: AppColors.textSecondary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name, style: AppTypography.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text(_formatPrice(item.product.price), style: AppTypography.body.copyWith(color: AppColors.tertiary)),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => context.read<CartCubit>().removeProduct(item.product.id),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: AppColors.surfaceContainerHigh,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(CupertinoIcons.minus, size: 16),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text('${item.quantity}', style: AppTypography.subtitle),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () => context.read<CartCubit>().addProduct(item.product),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: AppColors.surfaceContainerHigh,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(CupertinoIcons.add, size: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: state.items.length,
                    ),
                  ),
                ),

                // ─── 2. Địa chỉ giao hàng ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(CupertinoIcons.location_solid, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text('Địa chỉ giao hàng', style: AppTypography.subtitle.copyWith(color: AppColors.primary)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Thành phố (Fixed)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.building_2_fill, color: AppColors.textSecondary, size: 18),
                                const SizedBox(width: 12),
                                Text('Hà Nội, Việt Nam', style: AppTypography.body),
                                const Spacer(),
                                const Icon(CupertinoIcons.lock_fill, color: AppColors.textSecondary, size: 14),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Quận/Huyện (Picker)
                          GestureDetector(
                            onTap: () => _showDistrictPicker(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(16),
                                border: state.selectedDistrict.isEmpty
                                    ? Border.all(color: AppColors.error.withValues(alpha: 0.5))
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.map_pin_ellipse,
                                    color: state.selectedDistrict.isEmpty
                                        ? AppColors.textSecondary
                                        : AppColors.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      state.selectedDistrict.isEmpty
                                          ? 'Chọn Quận / Huyện *'
                                          : state.selectedDistrict,
                                      style: state.selectedDistrict.isEmpty
                                          ? AppTypography.bodySecondary
                                          : AppTypography.body,
                                    ),
                                  ),
                                  const Icon(CupertinoIcons.chevron_down, color: AppColors.textSecondary, size: 16),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Số nhà + Tên đường (TextField)
                          TextField(
                            controller: _addressController,
                            onChanged: (value) {
                              context.read<CartCubit>().setDeliveryAddress(value);
                            },
                            style: AppTypography.body,
                            decoration: InputDecoration(
                              hintText: 'Số nhà, tên đường... *',
                              hintStyle: AppTypography.bodySecondary,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 16, right: 12),
                                child: Icon(CupertinoIcons.house_fill, color: AppColors.textSecondary, size: 18),
                              ),
                              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              filled: true,
                              fillColor: AppColors.surfaceContainerHigh,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // ─── 3. Voucher & Đi nhẹ nói khẽ ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Voucher Box
                        GestureDetector(
                          onTap: () => _showVoucherPicker(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                              color: state.selectedVoucher != null
                                  ? AppColors.tertiary.withValues(alpha: 0.12)
                                  : AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: state.selectedVoucher != null
                                    ? AppColors.tertiary.withValues(alpha: 0.4)
                                    : AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.ticket,
                                  color: state.selectedVoucher != null ? AppColors.tertiary : AppColors.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: state.selectedVoucher != null
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.selectedVoucher!.code,
                                              style: AppTypography.subtitle.copyWith(color: AppColors.tertiary),
                                            ),
                                            Text(
                                              '-${_formatPrice(state.discount)}',
                                              style: AppTypography.caption.copyWith(color: AppColors.tertiary),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'Chọn mã giảm giá',
                                          style: AppTypography.subtitle.copyWith(color: AppColors.primary),
                                        ),
                                ),
                                Icon(
                                  CupertinoIcons.chevron_forward,
                                  color: state.selectedVoucher != null ? AppColors.tertiary : AppColors.primary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Đi nhẹ nói khẽ Toggle
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(CupertinoIcons.moon_stars_fill, color: AppColors.tertiary, size: 20),
                                      const SizedBox(width: 8),
                                      const Text('Đi nhẹ, nói khẽ', style: AppTypography.subtitle),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tài xế sẽ không gọi điện hay bấm chuông',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                              CupertinoSwitch(
                                value: state.quietDelivery,
                                activeTrackColor: AppColors.tertiary,
                                onChanged: (value) {
                                  context.read<CartCubit>().toggleQuietDelivery(value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── 4. Bill Summary ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        children: [
                          // Tạm tính
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tạm tính', style: AppTypography.bodySecondary),
                              Text(_formatPrice(state.subtotal), style: AppTypography.body),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Phí giao hàng
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phí giao hàng', style: AppTypography.bodySecondary),
                              Text(_formatPrice(state.shippingFee), style: AppTypography.body),
                            ],
                          ),
                          // Giảm giá (chỉ hiện khi có voucher)
                          if (state.selectedVoucher != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Voucher (${state.selectedVoucher!.code})', style: AppTypography.bodySecondary),
                                Text(
                                  '-${_formatPrice(state.discount)}',
                                  style: AppTypography.body.copyWith(color: AppColors.tertiary),
                                ),
                              ],
                            ),
                          ],
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(color: AppColors.surfaceContainerHighest),
                          ),
                          // Tổng cộng
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tổng cộng', style: AppTypography.h3),
                              Text(
                                _formatPrice(state.total),
                                style: AppTypography.h2.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
        // ─── Bottom CTA: Đặt món ───
        bottomSheet: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) return const SizedBox.shrink();
            return BlocBuilder<CheckoutCubit, CheckoutState>(
              builder: (context, checkoutState) {
                final isProcessing = checkoutState is CheckoutProcessing;
                return Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, -10),
                      )
                    ],
                  ),
                  child: PrimaryButton(
                    text: isProcessing ? 'Đang đặt...' : 'Đặt món ngay • ${_formatPrice(state.total)}',
                    icon: CupertinoIcons.rocket_fill,
                    isLoading: isProcessing,
                    onPressed: () => _handlePlaceOrder(context),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, CheckoutSuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              'Đặt món thành công!',
              style: AppTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Cú đêm chuẩn bị nạp năng lượng nhé.',
              style: AppTypography.bodySecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _billRow('Mã đơn', state.order.id.replaceAll('order_', '#')),
                  const SizedBox(height: 4),
                  _billRow('Giao đến', state.order.deliveryAddress),
                  const SizedBox(height: 4),
                  _billRow('Tổng tiền', _formatPrice(state.order.totalAmount)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Về trang chủ',
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  // Clear cart and reset checkout
                  this.context.read<CartCubit>().clearCart();
                  this.context.read<CheckoutCubit>().reset();
                  _addressController.clear();
                  // Navigate to home
                  this.context.go('/home');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: AppTypography.caption),
        Expanded(
          child: Text(value, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.right),
        ),
      ],
    );
  }
}
