import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/bloc/product_event.dart';
import 'package:flutterbloc/bloc/product_state.dart';
import 'package:flutterbloc/services/hive_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final HiveService _hiveService;

  ProductBloc(this._hiveService) : super(ProductInitial()) {
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
    try {
      final products = await _hiveService.getAllProduct();
      emit(ProductLoadedSuccess(products));
    } catch (e) {
      emit(ProductError('Failed to load products: $e'));
    }
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _hiveService.addProduct(event.product);
      final products = await _hiveService.getAllProduct();
      emit(
        ProductOperationSuccess(
          products,
          'Product ${event.product.name} added successfully!',
        ),
      );
    } catch (e) {
      emit(ProductError('Failed to add product: $e'));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _hiveService.updateProduct(event.product);
      final products = await _hiveService.getAllProduct();

      emit(
        ProductOperationSuccess(
          products,
          'Product ${event.product.name} updated successfully!',
        ),
      );
    } on Exception catch (e) {
      emit(ProductError('Failed to update product: $e'));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      await _hiveService.deleteProduct(event.productId);
      final products = await _hiveService.getAllProduct();
      emit(ProductOperationSuccess(products, 'Product deleted successfully!'));
    } on Exception catch (e) {
      emit(ProductError('Failed to delete product: $e'));
    }
  }

  @override
  Future<void> close() {
    _hiveService.closeBox();
    return super.close();
  }
}
