import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meatforte/models/http_excpetion.dart';

import 'package:http/http.dart' as http;
import 'package:meatforte/providers/auth.dart';
import 'package:provider/provider.dart';

const BASE_URL = 'https://meatstack.herokuapp.com';
//const BASE_URL = 'http://192.168.0.12:3000';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String layout;
  final String productType;
  final double gross;
  final double pieces;
  final int birds;
  final bool isInStock;
  final String cartItemId;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.imageUrl,
    @required this.layout,
    @required this.productType,
    @required this.isInStock,
    this.cartItemId,
    this.gross = 0.0,
    this.pieces = 0.0,
    this.birds = 0,
    this.isFavorite = false,
  });

  void _setFavValue(bool oldValue) {
    isFavorite = oldValue;
    notifyListeners();
  }

  Future<void> toggleFavorite(
    BuildContext context,
    String userId,
    String productId,
  ) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/toggleFavorite'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token,
        },
        body: json.encode(
          {
            'userId': userId,
            'productId': productId,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200 || responseData == null) {
        _setFavValue(oldStatus);
        throw HttpException(
          responseData['error'],
        );
      }
    } on HttpException catch (error) {
      throw error;
    } on SocketException catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }
}
