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
