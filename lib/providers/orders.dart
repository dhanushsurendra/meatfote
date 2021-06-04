import 'package:flutter/material.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/product.dart';

class OrderItem {
  final String id;
  final int quantity;
  final double totalPrice;
  final String date;
  final String paymentStatus;
  final String deliveryStatus;
  final List<Product> orderedProducts;
  final Address address;
  bool isExpanded;

  OrderItem({
    @required this.id,
    @required this.quantity,
    @required this.totalPrice,
    @required this.date,
    @required this.orderedProducts,
    @required this.paymentStatus,
    @required this.deliveryStatus,
    @required this.address,
    this.isExpanded = false,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItems = [
    OrderItem(
      id: '1',
      quantity: 3,
      totalPrice: 20.0,
      date: 'Thursday, April 29, 2021',
      orderedProducts: [
        Product(
            id: '1',
            name: 'Breast - boneless',
            price: 250,
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
            layout: "1",
            productType: 'chicken'),
        Product(
            id: '2',
            name: 'Leg - boneless',
            price: 250,
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
            layout: "1",
            productType: 'chicken'),
        Product(
            id: '3',
            name: 'Drumstick - Skinless',
            price: 220,
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
            layout: "2",
            productType: 'chicken'),
      ],
      isExpanded: false,
      paymentStatus: 'PAID',
      deliveryStatus: 'DELIVERED',
      address: Address(
        userId: '2',
        id: '1',
        businessName: 'Fish Shop',
        streetAddress: '#57 / 5a, 10th cross',
        locality: 'Lingarajapuram',
        landmark: 'Chandrikasoap Factory',
        city: 'Bangalore',
        pincode: 560084,
        timeOfDelivery: '6:00 pm',
        phoneNumber: '+91 9108735100',
      ),
    ),
    OrderItem(
      id: '2',
      quantity: 2,
      totalPrice: 20.0,
      date: 'Thursday, April 29, 2021',
      orderedProducts: [
        Product(
            id: '1',
            name: 'Breast - boneless',
            price: 250,
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
            layout: "1",
            productType: 'chicken'),
        Product(
            id: '3',
            name: 'Drumstick - Skinless',
            price: 220,
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
            layout: "2",
            productType: 'chicken'),
      ],
      isExpanded: false,
      paymentStatus: 'DUE',
      deliveryStatus: 'SHIPPED',
      address: Address(
        userId: '5',
        id: '1',
        businessName: 'Fish Shop',
        streetAddress: '#57 / 5a, 10th cross',
        locality: 'Lingarajapuram',
        landmark: 'Chandrikasoap Factory',
        city: 'Bangalore',
        pincode: 560084,
        timeOfDelivery: '6:00 pm',
        phoneNumber: '+91 9108735100',
      ),
    ),
    OrderItem(
      id: '3',
      quantity: 2,
      totalPrice: 20.0,
      date: 'Thursday, April 29, 2021',
      orderedProducts: [
        Product(
            id: '1',
            name: 'Breast - boneless',
            price: 250,
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
            layout: "1",
            productType: 'chicken'),
        Product(
            id: '3',
            name: 'Drumstick - Skinless',
            price: 220,
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
            layout: "2",
            productType: 'chicken'),
        Product(
            id: '4',
            name: 'Leg - boneless',
            price: 250,
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
            layout: "1",
            productType: 'chicken'),
        Product(
            id: '7',
            name: 'Drumstick - Skinless',
            price: 220,
            imageUrl:
                'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
            layout: "2",
            productType: 'chicken'),
      ],
      isExpanded: false,
      paymentStatus: 'DUE',
      deliveryStatus: 'PENDING',
      address: Address(
        userId: '2',
        id: '1',
        businessName: 'Fish Shop',
        streetAddress: '#57 / 5a, 10th cross',
        locality: 'Lingarajapuram',
        landmark: 'Chandrikasoap Factory',
        city: 'Bangalore',
        pincode: 560084,
        timeOfDelivery: '6:00 pm',
        phoneNumber: '+91 9108735100',
      ),
    ),
  ];

  List<OrderItem> get orderItems {
    return [..._orderItems];
  }

  OrderItem getOrder(String id) {
    return _orderItems.firstWhere((order) => order.id == id, orElse: () => null);
  }

  void toggleExpanded(int index) {
    _orderItems[index].isExpanded = !_orderItems[index].isExpanded;
    notifyListeners();
  }

  bool isExpanded(int index) {
    return _orderItems[index].isExpanded;
  }
}
