import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProduct {
  final ProductRepository repository;
  GetProduct(this.repository);

  Future<Product?> call(String id) async {
    return await repository.getProductById(id);
  }
}
