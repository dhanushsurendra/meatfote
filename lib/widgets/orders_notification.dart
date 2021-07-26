import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/date_time_format.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/notification.dart';
import 'package:meatforte/providers/orders.dart';
import 'package:meatforte/screens/order_details_screen.dart';
import 'package:meatforte/widgets/empty_image.dart';
import 'package:meatforte/widgets/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OrdersNotification extends StatefulWidget {
  const OrdersNotification({Key key}) : super(key: key);

  @override
  _OrdersNotificationState createState() => _OrdersNotificationState();
}

class _OrdersNotificationState extends State<OrdersNotification> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> _getNotifications(String userId) async {
    await Provider.of<Notifications>(context, listen: false)
        .fetchNotifications(context, userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context).userId;

    return FutureBuilder(
      future: Provider.of<Notifications>(context, listen: false)
          .fetchNotifications(context, userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: index != 0 ? 6.0 : 0.0,
                      bottom: 6.0,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120.0,
                      color: Colors.grey[300],
                    ),
                  ),
                );
              },
            ),
          );
        }

        if (snapshot.hasError) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () => _getNotifications(userId),
            child: ErrorHandler(
              message: 'Something went wrong. Please try again.',
              heightPercent: 0.7,
            ),
          );
        }

        return Provider.of<Notifications>(context).notifications.length == 0
            ? EmptyImage(
                message: 'No notifications yet :)',
                imageUrl: 'assets/images/empty_notification.png',
                heightPercent: 0.5,
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Provider.of<Notifications>(context, listen: false)
                      .notifications
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    final NotificationItem notification =
                        Provider.of<Notifications>(context, listen: false)
                            .notifications[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: () async {
                            await Provider.of<Notifications>(
                              context,
                              listen: false,
                            ).notificationRead(context, userId, notification.id);

                            await Provider.of<Orders>(context, listen: false)
                                .fetchOrder(
                              userId,
                              notification.orderId,
                            );

                            Navigator.of(context).push(
                              FadePageRoute(
                                childWidget: OrderDetailsScreen(
                                  title: 'Order Details',
                                  isOrderSummary: false,
                                  hasCancelOrder: false,
                                  isNotificationScreen: true,
                                  orderId: notification.orderId,
                                  // addressId: notification.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            color: notification.read
                                ? Colors.transparent
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 16.0,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      notification.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      notification.subtitle,
                                      maxLines: 3,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          DateTimeFormat.convertToAgo(
                                            notification.createdAt,
                                          ),
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              );
      },
    );
  }
}
