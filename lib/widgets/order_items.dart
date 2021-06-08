import 'package:flutter/material.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:meatforte/widgets/order_item.dart' as WidgetOrderItem;

class OrderItems extends StatefulWidget {
  final String type;
  final bool typeExists;

  const OrderItems({
    Key key,
    @required this.typeExists,
    @required this.type
  }) : super(key: key);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    return FutureBuilder(
      future: Provider.of<Orders>(context, listen: false).getOrders(userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) =>
          ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: Provider.of<Orders>(context).orderItems.length,
        itemBuilder: (BuildContext context, int index) {
          final OrderItem orderItem =
              Provider.of<Orders>(context, listen: false).orderItems[index];

          if (orderItem.orderStatus == widget.type) {
            return WidgetOrderItem.OrderItem(
              isAllOrders: false,
              index: index,
              orderItem: orderItem,
            );
          }

          if (orderItem.orderStatus == widget.type) {
            return WidgetOrderItem.OrderItem(
              isAllOrders: false,
              index: index,
              orderItem: orderItem,
            );
          }

          if (orderItem.orderStatus == widget.type) {
            return WidgetOrderItem.OrderItem(
              isAllOrders: false,
              index: index,
              orderItem: orderItem,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
