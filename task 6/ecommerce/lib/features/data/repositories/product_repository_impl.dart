import 'package:flutter/foundation.dart';
import 'package:ecommerce/core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../datasources/product_local_data_source copy.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getAllProducts();
        localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProducts = await localDataSource.getLastCachedProducts();
        return Right(localProducts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }


  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final remoteProducts = await remoteDataSource.fetchAllProducts();
      localDataSource.cacheProducts(remoteProducts);
      return remoteProducts;
    } catch (e) {
      return await localDataSource.getCachedProducts();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    final model = await remoteDataSource.fetchProductById(id);
    return model;
  }

  @override
  Future<void> insertProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    await remoteDataSource.addProduct(model);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    await remoteDataSource.updateProduct(model);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.removeProduct(id);
  }
}
