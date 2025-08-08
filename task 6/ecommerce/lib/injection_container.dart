import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:ui_pages/feature/product/data/datasource/network_info.dart';
import 'package:ui_pages/feature/product/data/datasource/product_local_data_source.dart';
import 'package:ui_pages/feature/product/data/datasource/product_remote_data_source.dart';

// Data Sources
import 'package:ui_pages/feature/product/data/repositories/product_repository_impl.dart';

// Repositories
import 'package:ui_pages/feature/product/domain/repositories/product_repository.dart';

// Use Cases
import 'package:ui_pages/feature/product/domain/usecase/create_product_uscase.dart';
import 'package:ui_pages/feature/product/domain/usecase/delete_product_usecase.dart';
import 'package:ui_pages/feature/product/domain/usecase/update_product_usecase.dart';
import 'package:ui_pages/feature/product/domain/usecase/get_all_peoducts_usecase.dart';
import 'package:ui_pages/feature/product/domain/usecase/search_product_usecase.dart';

// Bloc
import 'package:ui_pages/feature/product/presentation/bloc/product_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => Connectivity());
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // Data Sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: getIt()),
  );

  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<CreateProductUsecase>(
    () => CreateProductUsecase(getIt()),
  );

  getIt.registerLazySingleton<UpdateProductUsecase>(
    () => UpdateProductUsecase(getIt()),
  );

  getIt.registerLazySingleton<DeleteProductUsecase>(
    () => DeleteProductUsecase(getIt()),
  );

  getIt.registerLazySingleton<GetAllProductsUsecase>(
    () => GetAllProductsUsecase(getIt()),
  );

  getIt.registerLazySingleton<SearchProductsUsecase>(
    () => SearchProductsUsecase(getIt()),
  );

  // BLoC
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(
      createProductUsecase: getIt(),
      updateProductUsecase: getIt(),
      deleteProductUsecase: getIt(),
      getAllProductsUsecase: getIt(),
      searchProductUsecase: getIt(),
    ),
  );
}
