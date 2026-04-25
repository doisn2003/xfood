import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String avatarUrl;
  final int rewardPoints; // For Gamification (Cú Đêm)

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarUrl,
    required this.rewardPoints,
  });

  @override
  List<Object?> get props => [id, name, phone, avatarUrl, rewardPoints];
}
