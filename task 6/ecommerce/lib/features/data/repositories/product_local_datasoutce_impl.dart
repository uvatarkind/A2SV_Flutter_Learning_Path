import 'dart:convert';
import 'package:ecommerce/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import '../datasources/product_local_data_source copy.dart';

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
  
  @override
  Future<void> clearCache() {
    // TODO: implement clearCache
    throw UnimplementedError();
  }
  
  @override
  Future<List<ProductModel>> getCachedProducts() {
    // TODO: implement getCachedProducts
    throw UnimplementedError();
  }
}
