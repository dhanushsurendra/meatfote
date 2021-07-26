import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/orders.dart';
import 'package:meatforte/widgets/empty_image.dart';
import 'package:provider/provider.dart';
import 'package:meatforte/widgets/order_item.dart' as WidgetOrderItem;

import 'error_handler.dart';

class OrderItems extends StatefulWidget {
  final String type;
  final bool typeExists;

  const OrderItems({
    Key key,
    @required this.typeExists,
    @required this.type,
  }) : super(key: key);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
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

  Future<void> _getOrders(String userId) async {
    await Provider.of<Orders>(context, listen: false)
        .getOrders(userId, 'PRODUCTS', context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;
    return FutureBuilder(
      future: Provider.of<Orders>(context, listen: false)
          .getOrders(userId, 'PRODUCTS', context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).primaryColor,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () => _getOrders(userId),
            child: ErrorHandler(
              message: 'Something went wrong. Please try again.',
              heightPercent: 0.77,
            ),
          );
        }

        return Provider.of<Orders>(context).orderItems.length == 0
            ? EmptyImage(
                message: 'No orders yet. Start ordering some!',
                imageUrl: 'assets/images/empty.png',
                heightPercent: 0.7,
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  onRefresh: () => _getOrders(userId),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: Provider.of<Orders>(context).orderItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final OrderItem orderItem =
                          Provider.of<Orders>(context, listen: false)
                              .orderItems[index];

                      if (orderItem.orderStatus == widget.type) {
                        return WidgetOrderItem.OrderItem(
                          isAllOrders: false,
                          index: index,
                          orderItem: orderItem,
                          hasCancelOrder: orderItem.orderStatus == 'PENDING',
                          type: widget.type,
                        );
                      }

                      if (widget.typeExists &&
                          orderItem.paymentStatus == widget.type) {
                        return WidgetOrderItem.OrderItem(
                          isAllOrders: false,
                          index: index,
                          orderItem: orderItem,
                          hasCancelOrder: false,
                          type: widget.type,
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              );
      },
    );
  }
}
