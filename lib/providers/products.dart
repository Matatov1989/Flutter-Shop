import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:convert';
import './product.dart';

class ProductsRepository extends ChangeNotifier {
  List<Product> _items = [];
  List<Product> get items => _items.toList();
  List<Product> get favoriteItems => _items.where((prodItem) => prodItem.isFavorite).toList();
  Product findById(String id) => _items.firstWhere((prod) => prod.id == id);

  Future<void> fetchAndSetProducts() async {
    const url = 'https://tnopis-default-rtdb.europe-west1.firebasedatabase.app/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      log(json.decode(response.body).toString());

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://tnopis-default-rtdb.europe-west1.firebasedatabase.app/products.json';
    try {
      final response = await http.post(Uri.parse(url), body: json.encode({'title': product.title, 'description': product.description, 'price': product.price, 'imageUrl': product.imageUrl, 'isFavorite': product.isFavorite}));

      final newProduct = Product(id: json.decode(response.body)['name'], title: product.title, description: product.description, price: product.price, imageUrl: product.imageUrl);
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://tnopis-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            //   'isFavorite': newProduct.isFavorite
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      log('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://tnopis-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    // _items.removeWhere((prod) => prod.id==id);
    // TODO: why do you remove first from local?
    notifyListeners();

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
