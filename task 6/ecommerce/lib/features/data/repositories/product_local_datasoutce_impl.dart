import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import 'product_local_datasource.dart';

const CACHED_PRODUCTS = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonString = json.encode(products.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(CACHED_PRODUCTS, jsonString);
  }

  @override
  Future<List<ProductModel>> getLastProducts() {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final decoded = json.decode(jsonString) as List;
      final products = decoded
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
      return Future.value(products);
    } else {
      throw CacheException(); // Define this in your core/errors
    }
  }
}
