import 'package:equatable/equatable.dart';

enum OrderStatus { pending, preparing, delivering, completed, cancelled }

/// Chi tiết một sản phẩm trong đơn hàng
class OrderItemData extends Equatable {
  final String productId;
  final String productName;
  final String productImageUrl;
  final int price;
  final int quantity;

  const OrderItemData({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.price,
    required this.quantity,
  });

  int get subtotal => price * quantity;

  @override
  List<Object?> get props => [productId, productName, productImageUrl, price, quantity];
}

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final String shopId;
  final String shopName;
  final List<OrderItemData> items;
  final String deliveryAddress;
  final int subtotal;
  final int shippingFee;
  final int discountAmount;
  final int totalAmount;
  final String? voucherId;
  final OrderStatus status;
  final DateTime createdAt;
  final bool quietDelivery;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.items,
    required this.deliveryAddress,
    required this.subtotal,
    required this.shippingFee,
    this.discountAmount = 0,
    required this.totalAmount,
    this.voucherId,
    required this.status,
    required this.createdAt,
    this.quietDelivery = false,
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    String? shopId,
    String? shopName,
    List<OrderItemData>? items,
    String? deliveryAddress,
    int? subtotal,
    int? shippingFee,
    int? discountAmount,
    int? totalAmount,
    String? voucherId,
    OrderStatus? status,
    DateTime? createdAt,
    bool? quietDelivery,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      voucherId: voucherId ?? this.voucherId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      quietDelivery: quietDelivery ?? this.quietDelivery,
    );
  }

  @override
  List<Object?> get props => [
        id, userId, shopId, shopName, items, deliveryAddress,
        subtotal, shippingFee, discountAmount, totalAmount,
        voucherId, status, createdAt, quietDelivery,
      ];
}
