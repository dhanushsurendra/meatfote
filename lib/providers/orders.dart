import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/product.dart';

import 'package:http/http.dart' as http;

const BASE_URL = 'http://192.168.0.8:3000';

class OrderItem {
  final String id;
  final double totalPrice;
  final String paymentStatus;
  final String orderStatus;
  final List<Product> orderedProducts;
  final Address address;
  final String createdAt;
  bool isExpanded;

  OrderItem({
    @required this.id,
    @required this.totalPrice,
    @required this.orderedProducts,
    @required this.paymentStatus,
    @required this.orderStatus,
    @required this.address,
    @required this.createdAt,
    this.isExpanded = false,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  bool _fetchedData = false;

  List<OrderItem> get orderItems {
    return [..._orderItems];
  }

  OrderItem getOrder(String id) {
    return _orderItems.firstWhere((order) => order.id == id,
        orElse: () => null);
  }

  Future<void> getOrders(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/getOrders/$userId'),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      List<List<Product>> _orderedProducts = [];

      for (var i = 0; i < responseData['orders'].length; i++) {
        List<Product> _orderedProduct = [];
        for (var j = 0; j < responseData['orders'][i]['products'].length; j++) {
          _orderedProduct.add(
            new Product(
              id: responseData['orders'][i]['products'][j]['_id'],
              imageUrl: responseData['orders'][i]['products'][j]['product_id']
                  ['imageUrl'],
              layout: responseData['orders'][i]['products'][j]['product_id']
                  ['layout'],
              name: responseData['orders'][i]['products'][j]['product_id']
                  ['name'],
              price: responseData['orders'][i]['products'][j]['product_id']
                      ['price']
                  .toDouble(),
              productType: responseData['orders'][i]['products'][j]
                  ['product_id']['product_type'],
              gross:
                  responseData['orders'][i]['products'][j]['gross'].toDouble(),
              pieces: responseData['orders'][i]['products'][j]['pieces'] == null
                  ? 0.0
                  : responseData['orders'][i]['products'][j]['pieces']
                      .toDouble(),
              birds: responseData['orders'][i]['products'][j]['birds'] == null
                  ? 0
                  : responseData['orders'][i]['products'][j]['birds'],
            ),
          );
        }
        _orderedProducts.add(_orderedProduct);
      }

      List<OrderItem> _loadedOrderItems = [];

      for (int i = 0; i < responseData['orders'].length; i++) {
        final OrderItem orderItem = new OrderItem(
          id: responseData['orders'][i]['_id'],
          orderStatus: responseData['orders'][i]['order_status'],
          paymentStatus: responseData['orders'][i]['payment_status'],
          totalPrice: responseData['orders'][i]['total_price'].toDouble(),
          createdAt: responseData['orders'][i]['createdAt'],
          address: new Address(
            id: responseData['orders'][i]['address']['_id'],
            businessName: responseData['orders'][i]['address']['business_name'],
            streetAddress: responseData['orders'][i]['address']
                ['street_address'],
            city: responseData['orders'][i]['address']['city'],
            landmark: responseData['orders'][i]['address']['landmark'],
            locality: responseData['orders'][i]['address']['locality'],
            timeOfDelivery: responseData['orders'][i]['address']
                ['time_of_delivery'],
            phoneNumber: responseData['orders'][i]['address']['phoneNumber'],
            pincode: responseData['orders'][i]['address']['pincode'],
          ),
          orderedProducts: _orderedProducts[i],
        );

        _loadedOrderItems.add(orderItem);
      }

      _orderItems = _loadedOrderItems;

      _fetchedData = true;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> createOrder(
    String userId,
    String addressId,
    List<Product> products,
    double totalPrice,
  ) async {
    try {
      print(products[0].id);
      final response = await http.post(
        Uri.parse('$BASE_URL/createOrder/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'userId': userId,
            'addressId': addressId,
            'totalPrice': totalPrice,
            'products': products
                .map(
                  (product) => {
                    'id': product.id,
                    'gross': product.gross,
                    'pieces': product.pieces,
                    'birds': product.birds,
                  },
                )
                .toList(),
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      notifyListeners();
    } on HttpException catch (error) {
      throw error;
    } on SocketException catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  void toggleExpanded(int index) {
    _orderItems[index].isExpanded = !_orderItems[index].isExpanded;
    notifyListeners();
  }

  bool isExpanded(int index) {
    return _orderItems[index].isExpanded;
  }
}
