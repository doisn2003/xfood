import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:xfood/features/shared/models/order_model.dart';
import 'package:xfood/features/shared/repositories/order_repository.dart';
import 'package:xfood/features/shared/repositories/voucher_repository.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final OrderRepository orderRepository;
  final VoucherRepository voucherRepository;

  CheckoutCubit({
    required this.orderRepository,
    required this.voucherRepository,
  }) : super(const CheckoutInitial());

  Future<void> placeOrder(CartState cartState) async {
    // 1. Validate
    if (!cartState.isAddressValid) {
      emit(const CheckoutError('Vui lòng nhập đầy đủ địa chỉ giao hàng'));
      return;
    }
    if (cartState.items.isEmpty) {
      emit(const CheckoutError('Giỏ hàng đang trống'));
      return;
    }

    emit(const CheckoutProcessing());

    try {
      // 2. Build OrderItemData list
      final orderItems = cartState.items.map((item) => OrderItemData(
        productId: item.product.id,
        productName: item.product.name,
        productImageUrl: item.product.imageUrl,
        price: item.product.price,
        quantity: item.quantity,
      )).toList();

      // 3. Get shop info (use the first product's shopId)
      final shopId = cartState.items.first.product.shopId;

      // 4. Create order
      final order = OrderModel(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'u_1',
        shopId: shopId,
        shopName: '', // Will be filled by mock db lookup if needed later
        items: orderItems,
        deliveryAddress: cartState.fullAddress,
        subtotal: cartState.subtotal,
        shippingFee: cartState.shippingFee,
        discountAmount: cartState.discount,
        totalAmount: cartState.total,
        voucherId: cartState.selectedVoucher?.id,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        quietDelivery: cartState.quietDelivery,
      );

      // 5. Save order
      await orderRepository.placeOrder(order);

      // 6. Mark voucher as used
      if (cartState.selectedVoucher != null) {
        await voucherRepository.markAsUsed(cartState.selectedVoucher!.id);
      }

      emit(CheckoutSuccess(order));
    } catch (e) {
      emit(CheckoutError('Đặt hàng thất bại: $e'));
    }
  }

  void reset() {
    emit(const CheckoutInitial());
  }
}
