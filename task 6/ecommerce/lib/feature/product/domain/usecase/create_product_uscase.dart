import 'package:dartz/dartz.dart';
import 'package:ui_pages/core/error/failure.dart';

import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUsecase {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  Future<Either<Failure, void>> call(Product product) {
    return repository.createProduct(product);
  }
}
