import 'package:equatable/equatable.dart';

enum OrderStatus { pending, preparing, delivering, completed, cancelled }

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final String shopId;
  final List<String> productIds; // Simple representation for mock
  final int totalAmount;
  final int shippingFee;
  final OrderStatus status;
  final DateTime createdAt;
  final bool quietDelivery; // Chế độ "Đi nhẹ nói khẽ"

  const OrderModel({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.productIds,
    required this.totalAmount,
    required this.shippingFee,
    required this.status,
    required this.createdAt,
    this.quietDelivery = false,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        shopId,
        productIds,
        totalAmount,
        shippingFee,
        status,
        createdAt,
        quietDelivery,
      ];
}
