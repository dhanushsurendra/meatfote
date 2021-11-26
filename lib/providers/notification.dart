import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/user.dart';
import 'package:provider/provider.dart';

class NotificationItem {
  final String id;
  final String orderId;
  final String title;
  final String subtitle;
  final DateTime createdAt;
  bool read;

  NotificationItem({
    @required this.id,
    @required this.orderId,
    @required this.title,
    @required this.subtitle,
    @required this.read,
    @required this.createdAt,
  });
}

const BASE_URL = 'https://meatstack.herokuapp.com';

class Notifications with ChangeNotifier {
  List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications {
    return [..._notifications];
  }

  Future<void> fetchNotifications(BuildContext context, String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/getNotifications/$userId'),
        headers: {
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      List<NotificationItem> _loadedNotifications = [];

      for (var i = 0; i < responseData['notifications'].length; i++) {
        final notification = new NotificationItem(
          id: responseData['notifications'][i]['_id'],
          orderId: responseData['notifications'][i]['order_id'],
          title: responseData['notifications'][i]['title'],
          subtitle: responseData['notifications'][i]['subtitle'],
          read: responseData['notifications'][i]['read'],
          createdAt: DateTime.parse(
            responseData['notifications'][i]['createdAt'],
          ),
        );

        _loadedNotifications.add(notification);
      }

      _notifications = _loadedNotifications;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> notificationRead(
    BuildContext context,
    String userId,
    String notificationId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/updateNotification/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token,
        },
        body: json.encode(
          {
            'userId': userId,
            'notificationId': notificationId,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 201) {
        throw HttpException(responseData['error']);
      }

      final notificationIndex =
          _notifications.indexWhere((element) => element.id == notificationId);
      _notifications[notificationIndex].read = true;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
