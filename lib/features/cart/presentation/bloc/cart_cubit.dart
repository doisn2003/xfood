import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/features/shared/models/product_model.dart';
import 'package:xfood/features/shared/models/voucher_model.dart';

part 'cart_state.dart';

class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addProduct(ProductModel product) {
    final List<CartItem> updatedItems = List.from(state.items);
    final index = updatedItems.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      updatedItems[index] = CartItem(
        product: product,
        quantity: updatedItems[index].quantity + 1,
      );
    } else {
      updatedItems.add(CartItem(product: product, quantity: 1));
    }

    emit(state.copyWith(items: updatedItems));
  }

  void removeProduct(String productId) {
    final List<CartItem> updatedItems = List.from(state.items);
    final index = updatedItems.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (updatedItems[index].quantity > 1) {
        updatedItems[index] = CartItem(
          product: updatedItems[index].product,
          quantity: updatedItems[index].quantity - 1,
        );
      } else {
        updatedItems.removeAt(index);
      }
      emit(state.copyWith(items: updatedItems));
    }
  }

  void applyVoucher(VoucherModel voucher) {
    emit(state.copyWith(selectedVoucher: voucher));
  }

  void removeVoucher() {
    emit(state.copyWithClearVoucher());
  }

  void setDeliveryAddress(String address) {
    emit(state.copyWith(deliveryAddress: address));
  }

  void setDistrict(String district) {
    emit(state.copyWith(selectedDistrict: district));
  }

  void toggleQuietDelivery(bool value) {
    emit(state.copyWith(quietDelivery: value));
  }

  void clearCart() {
    emit(const CartState());
  }
}
