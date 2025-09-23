import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/bloc/product_event.dart';
import 'package:flutterbloc/bloc/product_state.dart';
import 'package:flutterbloc/models/product_model.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  List<Product> products = [];

  int index = 0;

  ProductBloc() : super(ProductInitial()) {
    on<LoadProduct>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    await Future.delayed(Duration(milliseconds: 500));
    emit(ProductLoadedSuccess(List.from(products)));
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    await Future.delayed(Duration(milliseconds: 500));
    final newProduct = event.product.copyWith(
      id: index++,
      name: event.product.name,
      price: event.product.price,
      stock: event.product.stock,
    );
    products.add(newProduct);
    emit(
      ProductOperationSuccess(
        List.from(products),
        'Product added successfully!',
      ),
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    await Future.delayed(Duration(milliseconds: 500));
    try {
      final index = products.indexWhere(
        (product) => product.id == event.product.id,
      );
      if (index != -1) {
        products[index] = event.product;
        emit(
          ProductOperationSuccess(
            List.from(products),
            'Product ${event.product.name} updated successfully!',
          ),
        );
      } else {
        emit(ProductError('Product not found'));
      }
    } on Exception catch (e) {
      emit(ProductError('Failed to update product: $e'));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    await Future.delayed(Duration(milliseconds: 500));
    try {
      products.removeWhere((product) => product.id == event.productId);
      emit(
        ProductOperationSuccess(
          List.from(products),
          'Product deleted successfully!',
        ),
      );
    } on Exception catch (e) {
      emit(ProductError('Failed to delete product: $e'));
    }
  }
}
