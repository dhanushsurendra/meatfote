import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/product.dart';

import 'package:http/http.dart' as http;

const BASE_URL = 'http://192.168.0.9:3000';

class Search with ChangeNotifier {
  String searchInput = '';
  List<Product> _searchProducts = [];

  List<Product> get searchProducts {
    return [..._searchProducts];
  }

  Future<void> getSearchResults(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/search?query=$searchInput&userId=$userId'),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      List<Product> _loadedProduct = [];

      for (var i = 0; i < responseData['products'].length; i++) {
        final Product product = new Product(
          id: responseData['products'][i]['_id'],
          name: responseData['products'][i]['name'],
          price: responseData['products'][i]['price'].toDouble(),
          imageUrl: responseData['products'][i]['image_url'],
          layout: responseData['products'][i]['layout'],
          productType: responseData['products'][i]['product_type'],
          isInStock: responseData['products'][i]['is_in_stock'],
        );

        _loadedProduct.add(product);
      }

      _searchProducts = _loadedProduct;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void getSearchQuery(String query) {
    searchInput = query;
  }

  void clearSearchQuery() {
    searchInput = '';
  }
}
