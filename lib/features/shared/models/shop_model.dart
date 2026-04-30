import 'package:equatable/equatable.dart';

class ShopModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final bool isOpen;
  final double rating;
  final int baseShippingFee; // For self-delivery
  final int feePerKm;
  final double latitude;
  final double longitude;
  final String description;
  final String openingHours;

  const ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.isOpen,
    required this.rating,
    required this.baseShippingFee,
    required this.feePerKm,
    this.latitude = 21.0285,
    this.longitude = 105.8542,
    this.description = '',
    this.openingHours = '08:00 - 22:00',
  });

  ShopModel copyWith({
    String? id,
    String? name,
    String? address,
    String? imageUrl,
    bool? isOpen,
    double? rating,
    int? baseShippingFee,
    int? feePerKm,
    double? latitude,
    double? longitude,
    String? description,
    String? openingHours,
  }) {
    return ShopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      isOpen: isOpen ?? this.isOpen,
      rating: rating ?? this.rating,
      baseShippingFee: baseShippingFee ?? this.baseShippingFee,
      feePerKm: feePerKm ?? this.feePerKm,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      openingHours: openingHours ?? this.openingHours,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        imageUrl,
        isOpen,
        rating,
        baseShippingFee,
        feePerKm,
        latitude,
        longitude,
        description,
        openingHours,
      ];
}
