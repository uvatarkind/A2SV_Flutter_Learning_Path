import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProduct {
  final ProductRepository repository;
  CreateProduct(this.repository);

  Future<void> call(Product product) async {
    return await repository.createProduct(product);
  }
}
