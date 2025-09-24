import 'package:flutterbloc/models/product_model.dart';
import 'package:hive/hive.dart';

class HiveService {
  static const String _productBoxName = 'products';

  Future<Box<Product>> openProductBox() async {
    return await Hive.openBox<Product>(_productBoxName);
  }

  Future<void> addProduct(Product product) async {
    final box = await openProductBox();
    await box.put(product.id, product);
  }

  Future<List<Product>> getAllProduct() async {
    final box = await openProductBox();
    return box.values.toList();
  }

  // get product by id
  Future<Product?> getProductById(String id) async {
    final box = await openProductBox();
    return box.get(id);
  }

  Future<void> updateProduct(Product product) async {
    final box = await openProductBox();
    return box.put(product.id, product);
  }

  Future<void> deleteProduct(String id) async {
    final box = await openProductBox();
    await box.delete(id);
  }

  Future<void> clearAllProducts() async {
    final box = await openProductBox();
    await box.clear();
  }

  Future<void> closeBox() async {
    await Hive.close();
  }
}
