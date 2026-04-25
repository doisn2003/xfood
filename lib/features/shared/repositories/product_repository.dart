import 'package:xfood/data_sources/env.dart';
import 'package:xfood/data_sources/mock_server/mock_database.dart';
import 'package:xfood/features/shared/models/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> getProductsByShopId(String shopId) async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    return MockDatabase.instance.products.where((p) => p.shopId == shopId).toList();
  }

  Future<List<ProductModel>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    return MockDatabase.instance.products;
  }
}
