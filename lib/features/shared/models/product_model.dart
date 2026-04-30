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

  ProductModel copyWith({
    String? id,
    String? shopId,
    String? categoryId,
    String? name,
    String? description,
    String? imageUrl,
    int? price,
    bool? isAvailable,
  }) {
    return ProductModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [id, shopId, categoryId, name, description, imageUrl, price, isAvailable];
}
