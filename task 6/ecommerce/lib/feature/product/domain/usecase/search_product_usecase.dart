import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';


class SearchProductsUsecase {
  final ProductRepository repository;

  SearchProductsUsecase(this.repository);

  Future<Either<Failure, Product>> call(String id) {
    return repository.searchProduct(id);
  }
}
