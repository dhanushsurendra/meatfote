import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationItem {
  final String id;
  final String orderId;
  final String title;
  final String subtitle;
  final bool read;
  final DateTime createdAt;

  NotificationItem({
    @required this.id,
    @required this.orderId,
    @required this.title,
    @required this.subtitle,
    @required this.read,
    @required this.createdAt,
  });
}

const BASE_URL = 'http://192.168.0.8:8080';

class Notifications with ChangeNotifier {
  List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications {
    return [..._notifications];
  }

  Future<void> fetchNotifications(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/getNotifications/$userId'),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      print(responseData);

      List<NotificationItem> _loadedNotifications = [];

      for (var i = 0; i < responseData['notifications'].length; i++) {
        final notification = new NotificationItem(
          id: responseData['notifications'][i]['_id'],
          orderId: responseData['notifications'][i]['order_id'],
          title: responseData['notifications'][i]['title'],
          subtitle: responseData['notifications'][i]['subtitle'],
          read: responseData['notifications'][i]['read'],
          createdAt: DateTime.parse(responseData['notifications'][i]['createdAt'])
        );

        _loadedNotifications.add(notification);
      }

      _notifications = _loadedNotifications;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

// NotificationItem(
//       id: '1',
//       orderId: '2',
//       subTitle:
//           'Pay your due amount of Rs. 12000/- to avoid legal notice within 24 hours',
//       read: false,
//       type: 'ACTIVITY',
//     ),
//     NotificationItem(
//       id: '1',
//       orderId: '2',
//       subTitle: 'Pre-payment of Rs. 12000/- is successfully completed.',
//       read: false,
//       type: 'ACTIVITY',
//     ),
//     NotificationItem(
//       id: '1',
//       orderId: '2',
//       subTitle:
//           'Pay your due amount of Rs. 12000/- to avoid legal notice within 24 hours',
//       read: false,
//       type: 'ORDERS',
//     ),
//     NotificationItem(
//       id: '1',
//       orderId: '3',
//       subTitle: 'Payment of Rs. 12000/- on COD is completed successfully.',
//       read: false,
//       type: 'ACTIVITY',
//     ),
//     NotificationItem(
//       id: '1',
//       orderId: '1',
//       subTitle: 'Pre-payment of Rs. 12000/- is successfully completed.',
//       read: false,
//       type: 'ORDERS',
//     ),
//     NotificationItem(
//       id: '1',
//       orderId: '2',
//       subTitle:
//           'Outstanding amount of Rs. 19000/- has been cleared successfully.',
//       read: true,
//       type: 'ORDERS',
//     ),
//     NotificationItem(
//       id: '1',
//       orderId: '1',
//       subTitle:
//           'Outstanding amount of Rs. 19000/- has been cleared successfully.',
//       read: true,
//       type: 'ACTIVITY',
//     ),
//     NotificationItem(
//       id: '1',
//       orderId: '2',
//       subTitle: 'Payment of Rs. 12000/- on COD is completed successfully.',
//       read: false,
//       type: 'ORDERS',
//     ),
