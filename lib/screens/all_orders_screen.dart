import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/orders.dart';
import 'package:meatforte/screens/search_input_screen.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/empty_image.dart';
import 'package:meatforte/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';
import 'package:meatforte/widgets/order_item.dart' as WidgetOrderItem;

class AllOrdersScreen extends StatelessWidget {
  final String type;
  final bool isSearchResult;

  const AllOrdersScreen({
    Key key,
    this.isSearchResult = false,
    this.type = 'PRODUCTS',
  }) : super(key: key);

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
              containsTrailingButton: true,
              trailingButtonIcon: Icon(
                Icons.search,
                color: Colors.white,
                size: 25.0,
              ),
              trailingButtonOnTap: () {
                Navigator.of(context).push(
                  FadePageRoute(
                    childWidget: SearchInputScreen(type: 'SEARCH_ORDERS'),
                  ),
                );
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<Orders>(context, listen: false)
                    .getOrders(userId, type, context),
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

                  return Provider.of<Orders>(context).orderItems.length == 0
                      ? EmptyImage(
                          message: 'No orders yet. Start ordering some!',
                          imageUrl: 'assets/images/empty.png',
                          heightPercent: 0.7,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 16.0,
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount:
                                Provider.of<Orders>(context, listen: false)
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
                                isSearchResult: isSearchResult,
                                hasCancelOrder:
                                    orderItem.orderStatus == 'PENDING',
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
