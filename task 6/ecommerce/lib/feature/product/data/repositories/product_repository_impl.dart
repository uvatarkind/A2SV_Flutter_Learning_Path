import 'package:dartz/dartz.dart';
import 'package:ui_pages/feature/product/data/models/product_model.dart';
import '../../../../core/error/failure.dart';
import '../../data/datasource/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasource/product_local_data_source.dart';
import '../datasource/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> createProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createProduct(ProductModel.fromEntity(product));

        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to create product: $e'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateProduct(ProductModel.fromEntity(product));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to update product: $e'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProduct(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to delete product: $e'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllproducts() async {
    if (await networkInfo.isConnected) {
      try {
        print("fetch products");
        final remoteProducts = await remoteDataSource.getAllProducts();
        await localDataSource.cacheProductList(remoteProducts); // optional
        return Right(remoteProducts);
      } catch (e) {
        print("fetch fail");
        return Left(ServerFailure(message: 'Failed to fetch products: $e'));
      }
    } else {
      try {
        final cachedProducts = await localDataSource.getLastProductList();
        return Right(cachedProducts);
      } catch (e) {
        return Left(CacheFailure(message: 'No cached products available'));
      }
    }
  }

  @override
  Future<Either<Failure, Product>> searchProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.searchProduct(id);
        return Right(product);
      } catch (e) {
        return Left(ServerFailure(message: 'Product not found: $e'));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
