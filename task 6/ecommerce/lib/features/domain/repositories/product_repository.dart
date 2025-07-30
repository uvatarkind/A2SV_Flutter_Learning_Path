import '../entities/product.dart';

abstract class ProductRepository {
  Future<Product?> getProductById(String id);
  Future<void> insertProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
