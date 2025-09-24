import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/bloc/product_bloc.dart';
import 'package:flutterbloc/bloc/product_event.dart';
import 'package:flutterbloc/bloc/product_state.dart';
import 'package:flutterbloc/models/product_model.dart';
import 'package:flutterbloc/screens/product_form_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ProductBloc>().add(LoadProduct());
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductFormScreen()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is ProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ProductError) {
            return Center(
              child: Column(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 64),
                  Text(state.errorMessage),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProductBloc>().add(LoadProduct()),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is ProductLoadedSuccess ||
              state is ProductOperationSuccess) {
            final products = state is ProductLoadedSuccess
                ? state.product
                : (state as ProductOperationSuccess).product;

            return _buildProductList(context, products);
          }
          return Center(child: Text('No products available'));
        },
      ),
    );
  }

  Widget _buildProductList(BuildContext context, List<Product> products) {
    if (products == [] || products.isEmpty) {
      return Center(child: Text('No products available...'));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getStockColor(product.stock),
                child: _getStockIcon(product.stock),
              ),
              title: Text(product.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price : ${product.price} Ks'),
                  Text(
                    'Stock : ${product.stock}',
                    style: TextStyle(color: _getStockTextColor(product.stock)),
                  ),
                  Text('id : ${product.id}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductFormScreen(product: product),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _showDeleteDialog(context, product),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Icon _getStockIcon(int stock) {
    if (stock > 20) return Icon(Icons.category);
    return Icon(Icons.warning);
  }

  Color _getStockColor(int stock) {
    if (stock > 20) return Colors.green;
    if (stock > 10) return Colors.orange;
    return Colors.red;
  }

  Color _getStockTextColor(int stock) {
    if (stock > 20) return Colors.green;
    if (stock > 10) return Colors.orange;
    return Colors.red;
  }

  void _showDeleteDialog(BuildContext context, Product product) {
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
                context.read<ProductBloc>().add(DeleteProduct(product.id));
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
