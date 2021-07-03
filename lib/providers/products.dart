import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/product.dart';

import 'package:http/http.dart' as http;

const BASE_URL = 'http://192.168.0.9:3000';

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> _userFavorites = [];

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favorites {
    return [..._userFavorites];
  }

  Future<List<String>> getFavorites(String userId) async {
    try {
      final favoritesResponse = await http.get(
        Uri.parse('$BASE_URL/favorites/$userId'),
      );

      final favoriteData = json.decode(favoritesResponse.body);

      if (favoriteData['statusCode'] != 200) {
        throw HttpException(favoriteData['error']);
      }

      final favoriteItem =
          favoriteData['products'][0]['favorites']['favorite_items'];

      List<String> favoriteItemIdArr = [];
      List<Product> favoriteItems = [];

      for (int i = 0; i < favoriteItem.length; i++) {
        favoriteItemIdArr.add(
          favoriteItem[i]['_id'],
        );

        final Product product = new Product(
          id: favoriteItem[i]['_id'],
          name: favoriteItem[i]['name'],
          price: favoriteItem[i]['price'].toDouble(),
          imageUrl: favoriteItem[i]['imageUrl'],
          layout: favoriteItem[i]['layout'],
          productType: favoriteItem[i]['product_type'],
          isInStock: favoriteItem[i]['is_in_stock'],
        );

        favoriteItems.add(product);
      }

      _userFavorites = favoriteItems;
      notifyListeners();

      return favoriteItemIdArr;
    } catch (error) {
      throw error;
    }
  }

  Future<void> getProducts(String userId) async {
    try {
      if (products.length == 0) {
        final response = await http.get(
          Uri.parse('$BASE_URL/products/$userId'),
        );

        final responseData = json.decode(response.body);

        if (responseData['statusCode'] != 200) {
          throw HttpException(responseData['error']);
        }

        print(responseData);

        List<String> favoriteArr = await getFavorites(userId);

        List<Product> _loadedProducts = [];

        for (var i = 0; i < responseData['products'].length; i++) {
          final Product product = new Product(
            id: responseData['products'][i]['_id'],
            name: responseData['products'][i]['name'],
            price: responseData['products'][i]['price'].toDouble(),
            imageUrl: responseData['products'][i]['imageUrl'],
            layout: responseData['products'][i]['layout'],
            productType: responseData['products'][i]['product_type'],
            isInStock: responseData['products'][i]['is_in_stock'],
            isFavorite: favoriteArr.contains(
              responseData['products'][i]['_id'],
            )
                ? true
                : false,
          );

          _loadedProducts.add(product);
        }

        _products = _loadedProducts;

        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteFavorite(String userId, String productId) async {
    try {
      final favoritesResponse = await http.post(
        Uri.parse('$BASE_URL/deleteFavorite/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'userId': userId,
            'productId': productId,
          },
        ),
      );

      final favoriteData = json.decode(favoritesResponse.body);

      if (favoriteData['statusCode'] != 201) {
        throw HttpException(favoriteData['error']);
      }

      var favProductIndex =
          _userFavorites.indexWhere((element) => element.id == productId);
      _userFavorites.removeAt(favProductIndex);

      var productIndex =
          _products.indexWhere((element) => element.id == productId);
      _products[productIndex].isFavorite = false;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
