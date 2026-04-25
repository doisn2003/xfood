import 'package:xfood/data_sources/env.dart';
import 'package:xfood/data_sources/mock_server/mock_database.dart';
import 'package:xfood/features/shared/models/shop_model.dart';

class ShopRepository {
  Future<List<ShopModel>> getPopularShops() async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    return MockDatabase.instance.shops;
  }

  Future<ShopModel> getShopById(String id) async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    return MockDatabase.instance.shops.firstWhere((shop) => shop.id == id);
  }
}
