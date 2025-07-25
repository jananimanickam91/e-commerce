import 'dart:convert';
import 'package:example_code/e-commerce_webpage/model/product_model.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final Logger log = Logger();

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
      log.d("ProductRepository::getProduct::${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception("No Data available");
      }
    } catch (error) {
      throw Exception("Error fetching data");
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await http.get(Uri.parse("https://fakestoreapi.com/products/$id"));
      log.d("ProductRepository::getProductById::${response.body}");
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception("No Product Available");
      }
    } catch (error) {
      throw Exception("Error Fetching Product");
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse("https://fakestoreapi.com/products/category/$category"));
      log.d("ProductRepository::getProductById::${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception("No products for category");
      }
    } catch (error) {
      throw Exception("Error Fetching Categories");
    }
  }
}
