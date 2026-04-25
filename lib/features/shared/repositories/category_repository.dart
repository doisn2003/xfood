import 'package:xfood/data_sources/env.dart';
import 'package:xfood/data_sources/mock_server/mock_database.dart';
import 'package:xfood/features/shared/models/category_model.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    return MockDatabase.instance.categories;
  }
}
