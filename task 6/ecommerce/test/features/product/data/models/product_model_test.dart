import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/features/data/models/product_model.dart';

void main() {
  final productJson = {
    'id': '1',
    'name': 'Test Product',
    'description': 'A product for testing',
    'price': 99.99,
    'imageUrl': 'http://test.com/image.png',
  };

  final productModel = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'A product for testing',
    price: 99.99,
    imageUrl: 'http://test.com/image.png',
  );

  test('should return a valid ProductModel from JSON', () {
    final result = ProductModel.fromJson(productJson);
    expect(result, isA<ProductModel>());
    expect(result.name, 'Test Product');
  });

  test('should return a JSON map from ProductModel', () {
    final result = productModel.toJson();
    expect(result, productJson);
  });
}
