import 'package:flutter/material.dart';
import 'package:meatforte/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:meatforte/widgets/order_item.dart' as WidgetOrderItem;

class OrderItems extends StatelessWidget {
  final String type;
  final String status;
  final bool typeExists;

  const OrderItems({
    Key key,
    @required this.typeExists,
    this.type = 'COMPLETED',
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(typeExists);
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
            Provider.of<Orders>(context, listen: false).orderItems.length,
        itemBuilder: (BuildContext context, int index) {
          final OrderItem orderItem =
              Provider.of<Orders>(context, listen: false).orderItems[index];

          if (typeExists && orderItem.paymentStatus == type) {
            print(orderItem.id);
            return WidgetOrderItem.OrderItem(
              isAllOrders: false,
              index: index,
              orderItem: orderItem,
            );
          }

          if (typeExists && orderItem.paymentStatus == type) {
            return WidgetOrderItem.OrderItem(
              isAllOrders: false,
              index: index,
              orderItem: orderItem,
            );
          }

          if (orderItem.deliveryStatus == status) {
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
