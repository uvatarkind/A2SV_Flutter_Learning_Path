import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../datasources/product_remote_data_source.dart';
import '../../../core/error/exceptions.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(
      Uri.parse('https://api.example.com/products'), // Replace with your base URL
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
  
  @override
  Future<void> addProduct(ProductModel product) {
    // TODO: implement addProduct
    throw UnimplementedError();
  }
  
  @override
  Future<List<ProductModel>> fetchAllProducts() {
    // TODO: implement fetchAllProducts
    throw UnimplementedError();
  }
  
  @override
  Future<ProductModel> fetchProductById(String id) {
    // TODO: implement fetchProductById
    throw UnimplementedError();
  }
  
  @override
  Future<void> removeProduct(String id) {
    // TODO: implement removeProduct
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateProduct(ProductModel product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}
