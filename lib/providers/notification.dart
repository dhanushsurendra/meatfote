import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String orderId;
  final String subTitle;
  final String type;
  final bool read;

  NotificationItem({
    @required this.id,
    @required this.orderId,
    @required this.subTitle,
    @required this.read,
    @required this.type,
  });
}

class Notifications with ChangeNotifier {
  final List<NotificationItem> _activities = [NotificationItem(
      id: '1',
      orderId: '2',
      subTitle:
          'Pay your due amount of Rs. 12000/- to avoid legal notice within 24 hours',
      read: false,
      type: 'ACTIVITY',
    ),
    NotificationItem(
      id: '1',
      orderId: '2',
      subTitle: 'Pre-payment of Rs. 12000/- is successfully completed.',
      read: false,
      type: 'ACTIVITY',
    ),
    NotificationItem(
      id: '1',
      orderId: '2',
      subTitle:
          'Pay your due amount of Rs. 12000/- to avoid legal notice within 24 hours',
      read: false,
      type: 'ORDERS',
    ),
    NotificationItem(
      id: '1',
      orderId: '3',
      subTitle: 'Payment of Rs. 12000/- on COD is completed successfully.',
      read: false,
      type: 'ACTIVITY',
    ),
    NotificationItem(
      id: '1',
      orderId: '1',
      subTitle: 'Pre-payment of Rs. 12000/- is successfully completed.',
      read: false,
      type: 'ORDERS',
    ),
    NotificationItem(
      id: '1',
      orderId: '2',
      subTitle:
          'Outstanding amount of Rs. 19000/- has been cleared successfully.',
      read: true,
      type: 'ORDERS',
    ),
    NotificationItem(
      id: '1',
      orderId: '1',
      subTitle:
          'Outstanding amount of Rs. 19000/- has been cleared successfully.',
      read: true,
      type: 'ACTIVITY',
    ),
    NotificationItem(
      id: '1',
      orderId: '2',
      subTitle: 'Payment of Rs. 12000/- on COD is completed successfully.',
      read: false,
      type: 'ORDERS',
    ),];

  List<NotificationItem> get activities {
    return [..._activities];
  }
}
