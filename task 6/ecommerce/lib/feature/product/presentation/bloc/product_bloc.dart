import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_pages/feature/product/domain/usecase/get_all_peoducts_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../domain/usecase/create_product_uscase.dart';
import '../../domain/usecase/update_product_usecase.dart';
import '../../domain/usecase/delete_product_usecase.dart';
import '../../domain/usecase/search_product_usecase.dart';
 // only if you support loading list

class ProductBloc extends Bloc<ProductEvent, ProductState> {

  final CreateProductUsecase createProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;
  final GetAllProductsUsecase getAllProductsUsecase;
  final SearchProductsUsecase searchProductUsecase;


  ProductBloc({
    
    required this.createProductUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
    required this.getAllProductsUsecase,
    required this.searchProductUsecase,

  }) : super(ProductInitial()) {

    on<CreateProductEvent>((event, emit) async {
      emit(ProductLoading());
      final result = await createProductUsecase(event.product);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (_) => emit(ProductOperationSuccess()),
      );
    });

    on<UpdateProductEvent>((event, emit) async {
      emit(ProductLoading());
      final result = await updateProductUsecase(event.product);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (_) => emit(ProductOperationSuccess()),
      );
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(ProductLoading());
      final result = await deleteProductUsecase(event.productId);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (_) => emit(ProductOperationSuccess()),
      );
    });
    on<GetAllProductsEvent>((event, emit) async {
    emit(ProductLoading());
    final result = await getAllProductsUsecase();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  });

  on<SearchProductEvent>((event, emit) async {
    emit(ProductLoading());
    final result = await searchProductUsecase(event.productId);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded([products])),
    );
  });


  }
}
