import 'package:equatable/equatable.dart';
import 'package:flutterbloc/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoadedSuccess extends ProductState {
  final List<Product> product;
  const ProductLoadedSuccess(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductOperationSuccess extends ProductState {
  final List<Product> product;
  final String successMessage;
  const ProductOperationSuccess(this.product, this.successMessage);

  @override
  List<Object?> get props => [product, successMessage];
}

class ProductError extends ProductState {
  final String errorMessage;
  const ProductError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
