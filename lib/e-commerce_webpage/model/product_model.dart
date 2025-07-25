import 'package:example_code/e-commerce_webpage/model/rating_model.dart';
import 'package:logger/logger.dart';
import 'package:uuid/v7.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  static Product getInstance() {
    return Product(id: const UuidV7().generate(), title: "", price: 0.0, description: '', category: '', image: '', rating: Rating.getInstance());
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final Logger log = Logger();
    try {
      return Product(
        id: json['id'].toString(),
        title: json['title'],
        price: (json['price'] as num).toDouble(),
        description: json['description'],
        category: json['category'],
        image: json['image'],
        rating: Rating.fromJson(json['rating']),
      );
    } catch (error) {
      log.d("Product::fromJson::$error");
      return Product.getInstance();
    }
  }
}
