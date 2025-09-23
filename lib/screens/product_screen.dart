import 'package:flutter/material.dart';
import 'package:flutterbloc/models/product_model.dart';
import 'package:flutterbloc/screens/product_form_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];

  int _index = 0;

  void _addNewProduct(Product newProduct) {
    setState(() {
      products.add(
        Product(
          id: _index++,
          name: newProduct.name,
          price: newProduct.price,
          stock: newProduct.stock,
        ),
      );
    });
  }

  void _updateProduct(int id, Product updateProduct) {
    setState(() {
      int index = products.indexWhere((product) => product.id == id);
      if (index != -1) {
        products[index] = updateProduct.copyWith(id: id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductFormScreen()),
              );

              if (result != null) {
                _addNewProduct(result);
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: products.isEmpty || products == []
          ? Center(child: Text('No products available...'))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search ...',
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Product product = products[index];

                        return Card(
                          child: ListTile(
                            title: Text(product.name),
                            subtitle: Text(
                              '${product.price} Ks ~ ${product.stock} Stock',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _editProduct(product),
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () => _showDeleteDialog(product),
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _editProduct(Product product) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );
    if (result != null) {
      _updateProduct(product.id, result);
    }
  }

  void _deleteProduct(int productId) {
    setState(() {
      products.removeWhere((product) => product.id == productId);
    });
  }

  void _showDeleteDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${product.name}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteProduct(product.id);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
