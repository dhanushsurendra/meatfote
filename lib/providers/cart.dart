import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/product.dart';

import 'package:http/http.dart' as http;

const BASE_URL = 'http://192.168.0.8:8080';

class Cart with ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems {
    return [..._cartItems];
  }

  bool get isCartItemsInStock {
    bool _isInStock = true;

    for (var i = 0; i < _cartItems.length; i++) {
      if (!_cartItems[i].isInStock) {
        _isInStock = false;
      }
    }

    return _isInStock;
  }

  double totalPrice = 0;

  double get total {
    double _total = 0.0;
    for (var i = 0; i < _cartItems.length; i++) {
      if ((_cartItems[i].gross > 0.0 &&
              _cartItems[i].birds == 0 &&
              _cartItems[i].pieces == 0.0) ||
          (_cartItems[i].birds == 0 &&
              _cartItems[i].gross > 0.0 &&
              _cartItems[i].pieces >= 0.0)) {
        _total += _cartItems[i].gross * _cartItems[i].price;
      } else if (_cartItems[i].birds > 0 &&
          _cartItems[i].gross > 0 &&
          _cartItems[i].pieces == 0) {
        _total +=
            _cartItems[i].gross * _cartItems[i].price * _cartItems[i].birds;
      }
    }

    totalPrice = _total;

    return _total;
  }

  Future<void> getCartItems(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/getCartItems/$userId'),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      List<Product> cartItemsArr = [];

      for (int i = 0; i < responseData['products'].length; i++) {
        print(responseData['products'][i]['pieces'] == null);

        final Product product = new Product(
          id: responseData['products'][i]['product_id']['_id'],
          name: responseData['products'][i]['product_id']['name'],
          price: responseData['products'][i]['product_id']['price'].toDouble(),
          imageUrl: responseData['products'][i]['product_id']['imageUrl'],
          layout: responseData['products'][i]['product_id']['layout'],
          productType: responseData['products'][i]['product_id']
              ['product_type'],
          isInStock: responseData['products'][i]['product_id']['is_in_stock'],
          gross: responseData['products'][i]['gross'].toDouble(),
          pieces: responseData['products'][i]['pieces'] == null
              ? 0.0
              : responseData['products'][i]['pieces'].toDouble(),
          birds: responseData['products'][i]['birds'] == null
              ? 0
              : responseData['products'][i]['birds'],
        );

        cartItemsArr.add(product);
      }

      _cartItems = cartItemsArr;

      print(_cartItems);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addToCart(
    String userId,
    String productId, {
    double gross,
    double pieces,
    int birds,
  }) async {
    print(birds);

    try {
      final favoritesResponse = await http.post(
        Uri.parse('$BASE_URL/addToCart/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'userId': userId,
            'productId': productId,
            'gross': gross,
            'pieces': pieces,
            'birds': birds,
          },
        ),
      );

      final cartData = json.decode(favoritesResponse.body);

      if (cartData['statusCode'] != 201) {
        throw HttpException(cartData['error']);
      }

      print(cartData);

      final product = new Product(
        id: cartData['product']['_id'],
        name: cartData['product']['product_id']['name'],
        price: cartData['product']['product_id']['price'].toDouble(),
        imageUrl: cartData['product']['product_id']['imageUrl'],
        productType: cartData['product']['product_id']['product_type'],
        layout: cartData['product']['product_id']['layout'],
        isInStock: cartData['product']['product_id']['is_in_stock'],
        gross: cartData['product']['gross'].toDouble(),
        pieces: cartData['product']['pieces'] == null
            ? 0.0
            : cartData['product']['pieces'].toDouble(),
        birds: cartData['product']['birds'] == null
            ? 0
            : cartData['product']['birds'],
      );

      _cartItems.add(product);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteCartItem(String userId, String cartItemId) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$BASE_URL/deleteCartItem',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'userId': userId,
            'cartItemId': cartItemId,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 201) {
        throw HttpException(responseData['error']);
      }

      var _cartItemIndex =
          _cartItems.indexWhere((element) => element.id == cartItemId);
      _cartItems.removeAt(_cartItemIndex);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
