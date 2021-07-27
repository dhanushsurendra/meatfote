import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/product.dart';

import 'package:http/http.dart' as http;
import 'package:meatforte/providers/search.dart';
import 'package:provider/provider.dart';

const BASE_URL = 'http://192.168.0.8:3000';

class OrderItem {
  final String id;
  final double totalPrice;
  final String paymentStatus;
  final String orderStatus;
  final List<Product> orderedProducts;
  final Address address;
  final String createdAt;
  final String orderRejectedReason;
  final String orderDeliveryDate;
  String orderDeliveredTime;
  bool isExpanded;

  OrderItem({
    @required this.id,
    @required this.totalPrice,
    @required this.orderedProducts,
    @required this.paymentStatus,
    @required this.orderStatus,
    @required this.address,
    @required this.createdAt,
    @required this.orderRejectedReason,
    this.orderDeliveryDate,
    this.orderDeliveredTime,
    this.isExpanded = false,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItems = [];
  OrderItem orderItem;

  List<OrderItem> get orderItems {
    return [..._orderItems];
  }

  OrderItem getOrder(String id) {
    return _orderItems.firstWhere((order) => order.id == id,
        orElse: () => null);
  }

  Future<void> getOrders(
    String userId,
    String type,
    BuildContext context,
  ) async {
    try {
      final url = type == 'PRODUCTS'
          ? '$BASE_URL/getOrders/$userId/user'
          : '$BASE_URL/searchOrders?userId=$userId&query=${Provider.of<Search>(context, listen: false).searchInput}&type=user';
      final response = await http.get(
        Uri.parse(url),
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
              isInStock: responseData['orders'][i]['products'][j]['product_id']
                  ['is_in_stock'],
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
          orderDeliveryDate: responseData['orders'][i]['order_delivery_date'],
          orderDeliveredTime: responseData['orders'][i]['order_delivered_time'],
          address: new Address(
            id: responseData['orders'][i]['address']['_id'],
            businessName: responseData['orders'][i]['address']['business_name'],
            timeOfDelivery: responseData['orders'][i]['address']
                ['time_of_delivery'],
            phoneNumber: responseData['orders'][i]['address']['phone_number'],
            address: responseData['orders'][i]['address']['address'],
          ),
          orderedProducts: _orderedProducts[i],
          orderRejectedReason: responseData['orders'][i]
              ['order_rejection_reason'],
        );

        _loadedOrderItems.add(orderItem);
      }

      _orderItems = _loadedOrderItems;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> createOrder(
    BuildContext context,
    String userId,
    String addressId,
    List<Product> products,
    double totalPrice,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/createOrder/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token,
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

  Future<void> cancelOrder(
    BuildContext context,
    String userId,
    String orderId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/cancelOrder/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token,
        },
        body: json.encode(
          {
            'userId': userId,
            'orderId': orderId,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> reorder(
    BuildContext context,
    String userId,
    String orderId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/reorder/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + '',
        },
        body: json.encode(
          {
            'userId': userId,
            'orderId': orderId,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchOrder(String userId, String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/getOrder?userId=$userId&orderId=$orderId'),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      List<Product> _orderedProducts = [];

      for (var i = 0; i < responseData['order']['products'].length; i++) {
        _orderedProducts.add(
          new Product(
            id: responseData['order']['products'][i]['_id'],
            imageUrl: responseData['order']['products'][i]['product_id']
                ['imageUrl'],
            layout: responseData['order']['products'][i]['product_id']
                ['layout'],
            name: responseData['order']['products'][i]['product_id']['name'],
            price: responseData['order']['products'][i]['product_id']['price']
                .toDouble(),
            productType: responseData['order']['products'][i]['product_id']
                ['product_type'],
            isInStock: responseData['order']['products'][i]['product_id']
                ['is_in_stock'],
            gross: responseData['order']['products'][i]['gross'].toDouble(),
            pieces: responseData['order']['products'][i]['pieces'] == null
                ? 0.0
                : responseData['order']['products'][i]['pieces'].toDouble(),
            birds: responseData['order']['products'][i]['birds'] == null
                ? 0
                : responseData['order']['products'][i]['birds'],
          ),
        );
      }

      final OrderItem loadedOrderItem = new OrderItem(
        id: responseData['order']['_id'],
        orderStatus: responseData['order']['order_status'],
        paymentStatus: responseData['order']['payment_status'],
        totalPrice: responseData['order']['total_price'].toDouble(),
        createdAt: responseData['order']['createdAt'],
        orderRejectedReason: responseData['order']['order_rejection_reason'],
        address: new Address(
          id: responseData['order']['address']['_id'],
          address: responseData['order']['address']['address'],
          businessName: responseData['order']['address']['business_name'],
          phoneNumber: responseData['order']['address']['phone_number'],
          timeOfDelivery: responseData['order']['address']['time_of_delivery'],
        ),
        orderedProducts: _orderedProducts,
      );

      orderItem = loadedOrderItem;

      notifyListeners();
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
