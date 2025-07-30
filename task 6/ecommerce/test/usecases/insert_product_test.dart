// test/usecases/insert_product_test.dart
import 'package:ecommerce/features/domain/usecases/insert_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/features/data/repositories/product_repository_impl.dart';
import 'package:ecommerce/features/domain/entities/product.dart';
import 'package:ecommerce/features/domain/repositories/product_repository.dart';

void main() {
  test('should insert a product successfully', () async {
    final repo = ProductRepositoryImpl();
    final insertUsecase = InsertProduct(repo);

    final product = Product(
      id: '1',
      name: 'Test Product',
      description: 'Desc',
      price: 10.0,
      imageUrl: 'https://image.jpg',
    );

    await insertUsecase(product);
    final fetched = await repo.getProductById('1');
    expect(fetched?.name, 'Test Product');
  });
}
