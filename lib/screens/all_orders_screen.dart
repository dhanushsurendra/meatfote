import 'package:flutter/material.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/orders.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';
import 'package:meatforte/widgets/order_item.dart' as WidgetOrderItem;

class AllOrdersScreen extends StatelessWidget {
  const AllOrdersScreen({Key key}) : super(key: key);

  static const routeName = '/all-orders-screen';

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Orders',
              containsBackButton: true,
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<Orders>(context, listen: false)
                    .getOrders(userId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: OrdersShimmer(),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                    ),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: Provider.of<Orders>(context, listen: false)
                          .orderItems
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        final OrderItem orderItem =
                            Provider.of<Orders>(context, listen: false)
                                .orderItems[index];
                        return WidgetOrderItem.OrderItem(
                          orderItem: orderItem,
                          isAllOrders: true,
                          index: index,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
