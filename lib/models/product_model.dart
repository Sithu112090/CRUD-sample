import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  Product copyWith({String? id, String? name, double? price, int? stock}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }

  @override
  List<Object?> get props => [id, name, price, stock];

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'stock': stock};
  }

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'],
      name: data['name'],
      price: data['price'],
      stock: data['stock'],
    );
  }
}
