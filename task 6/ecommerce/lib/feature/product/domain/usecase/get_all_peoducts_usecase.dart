import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

class GetAllProductsUsecase {
  final ProductRepository repository;

  GetAllProductsUsecase(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getAllproducts();
  }
}
