import '../../domain/entities/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}

class ProductOperationSuccess extends ProductState {}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
