import 'package:equatable/equatable.dart';

class VoucherModel extends Equatable {
  final String id;
  final String code;
  final String description;
  final int discountAmount;
  final bool isFreeship;
  final bool isUsed;
  final int minOrderAmount;

  const VoucherModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discountAmount,
    this.isFreeship = false,
    this.isUsed = false,
    this.minOrderAmount = 0,
  });

  VoucherModel copyWith({
    String? id,
    String? code,
    String? description,
    int? discountAmount,
    bool? isFreeship,
    bool? isUsed,
    int? minOrderAmount,
  }) {
    return VoucherModel(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      discountAmount: discountAmount ?? this.discountAmount,
      isFreeship: isFreeship ?? this.isFreeship,
      isUsed: isUsed ?? this.isUsed,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
    );
  }

  @override
  List<Object?> get props => [id, code, description, discountAmount, isFreeship, isUsed, minOrderAmount];
}
