import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String shopId;
  final String categoryId;
  final String name;
  final String description;
  final String imageUrl;
  final int price;
  final bool isAvailable;

  const ProductModel({
    required this.id,
    required this.shopId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [id, shopId, categoryId, name, description, imageUrl, price, isAvailable];
}
