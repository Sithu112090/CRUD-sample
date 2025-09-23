import 'package:flutterbloc/models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoadedSuccess extends ProductState {
  final List<Product> product;
  ProductLoadedSuccess(this.product);
}

class ProductOperationSuccess extends ProductState {
  final List<Product> product;
  final String successMessage;
  ProductOperationSuccess(this.product, this.successMessage);
}

class ProductError extends ProductState {
  final String errorMessage;
  ProductError(this.errorMessage);
}
