import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_pages/core/error/exeption.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getLastProductList();
  Future<void> cacheProductList(List<ProductModel> products);
}

const CACHED_PRODUCTS = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProductList(List<ProductModel> products) {
    final jsonString = json.encode(products.map((e) => e.toJson()).toList());
    return sharedPreferences.setString(CACHED_PRODUCTS, jsonString);
  }

  @override
  Future<List<ProductModel>> getLastProductList() {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      final List data = json.decode(jsonString);
      return Future.value(data.map((e) => ProductModel.fromJson(e)).toList());
    } else {
      throw CacheException();
    }
  }
}
