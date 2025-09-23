import 'package:flutterbloc/models/product_model.dart';

abstract class ProductEvent {}

class LoadProduct extends ProductEvent {}

class AddProduct extends ProductEvent {
  final Product product;
  AddProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final Product product;
  UpdateProduct(this.product);
}

class DeleteProduct extends ProductEvent {
  final int productId;
  DeleteProduct(this.productId);
}
