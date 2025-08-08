import 'package:dartz/dartz.dart';
import 'package:ui_pages/core/error/failure.dart';

import '../repositories/product_repository.dart';

class DeleteProductUsecase {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  Future<Either<Failure,void>> call(String id) async {
    return repository.deleteProduct(id);
  }
}
