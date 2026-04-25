import 'package:equatable/equatable.dart';

class VoucherModel extends Equatable {
  final String id;
  final String code;
  final String description;
  final int discountAmount;
  final bool isFreeship;

  const VoucherModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discountAmount,
    this.isFreeship = false,
  });

  @override
  List<Object?> get props => [id, code, description, discountAmount, isFreeship];
}
