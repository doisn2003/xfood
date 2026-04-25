part of 'checkout_cubit.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();

  @override
  List<Object?> get props => [];
}

class CheckoutProcessing extends CheckoutState {
  const CheckoutProcessing();

  @override
  List<Object?> get props => [];
}

class CheckoutSuccess extends CheckoutState {
  final OrderModel order;
  const CheckoutSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class CheckoutError extends CheckoutState {
  final String message;
  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}
