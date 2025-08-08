import 'package:dartz/dartz.dart';
import 'package:ui_pages/core/error/failure.dart';

import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUsecase {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  Future<Either<Failure,void>> call(Product product) async {
    return repository.updateProduct(product);
  }
}
