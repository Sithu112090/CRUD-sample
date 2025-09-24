import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
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
