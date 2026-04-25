part of 'cart_cubit.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final VoucherModel? selectedVoucher;
  final bool quietDelivery;

  const CartState({
    this.items = const [],
    this.selectedVoucher,
    this.quietDelivery = false,
  });

  int get subtotal {
    return items.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  int get total {
    int currentTotal = subtotal;
    if (selectedVoucher != null && currentTotal > 0) {
      currentTotal -= selectedVoucher!.discountAmount;
    }
    return currentTotal > 0 ? currentTotal : 0;
  }

  CartState copyWith({
    List<CartItem>? items,
    VoucherModel? selectedVoucher,
    bool? quietDelivery,
  }) {
    return CartState(
      items: items ?? this.items,
      selectedVoucher: selectedVoucher ?? this.selectedVoucher,
      quietDelivery: quietDelivery ?? this.quietDelivery,
    );
  }

  @override
  List<Object?> get props => [items, selectedVoucher, quietDelivery];
}
