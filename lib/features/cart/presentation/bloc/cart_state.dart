part of 'cart_cubit.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final VoucherModel? selectedVoucher;
  final bool quietDelivery;
  final String deliveryAddress; // Số nhà + Tên đường
  final String selectedDistrict; // Quận đã chọn

  const CartState({
    this.items = const [],
    this.selectedVoucher,
    this.quietDelivery = false,
    this.deliveryAddress = '',
    this.selectedDistrict = '',
  });

  int get subtotal {
    return items.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  int get shippingFee => 15000; // Phí giao hàng mặc định mock

  int get discount {
    if (selectedVoucher == null) return 0;
    if (selectedVoucher!.isFreeship) return shippingFee;
    return selectedVoucher!.discountAmount;
  }

  int get total {
    int result = subtotal + shippingFee - discount;
    return result > 0 ? result : 0;
  }

  /// Địa chỉ đầy đủ để hiển thị
  String get fullAddress {
    if (deliveryAddress.isEmpty && selectedDistrict.isEmpty) return '';
    final parts = <String>[];
    if (deliveryAddress.isNotEmpty) parts.add(deliveryAddress);
    if (selectedDistrict.isNotEmpty) parts.add(selectedDistrict);
    parts.add('Hà Nội');
    return parts.join(', ');
  }

  /// Kiểm tra đã nhập đủ địa chỉ chưa
  bool get isAddressValid => deliveryAddress.trim().isNotEmpty && selectedDistrict.isNotEmpty;

  CartState copyWith({
    List<CartItem>? items,
    VoucherModel? selectedVoucher,
    bool? quietDelivery,
    String? deliveryAddress,
    String? selectedDistrict,
  }) {
    return CartState(
      items: items ?? this.items,
      selectedVoucher: selectedVoucher ?? this.selectedVoucher,
      quietDelivery: quietDelivery ?? this.quietDelivery,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
    );
  }

  /// copyWith đặc biệt để xóa voucher (vì null trong copyWith = giữ nguyên)
  CartState copyWithClearVoucher() {
    return CartState(
      items: items,
      selectedVoucher: null,
      quietDelivery: quietDelivery,
      deliveryAddress: deliveryAddress,
      selectedDistrict: selectedDistrict,
    );
  }

  @override
  List<Object?> get props => [items, selectedVoucher, quietDelivery, deliveryAddress, selectedDistrict];
}
