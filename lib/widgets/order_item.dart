import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/orders.dart' as OrderItemClass;
import 'package:meatforte/providers/orders.dart';
import 'package:meatforte/screens/cart_screen.dart';
import 'package:meatforte/screens/order_details_screen.dart';
import 'package:meatforte/widgets/cart_dropdown_items.dart';
import 'package:provider/provider.dart';

class OrderItem extends StatelessWidget {
  final OrderItemClass.OrderItem orderItem;
  final int index;
  final bool isAllOrders;

  const OrderItem({
    Key key,
    @required this.orderItem,
    @required this.index,
    @required this.isAllOrders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 2.0),
              blurRadius: 6.0,
              color: Colors.black12,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Id: ${orderItem.id}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.rupeeSign,
                        size: 14.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        orderItem.totalPrice.toStringAsFixed(2),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Text(
                'Quantity: ${orderItem.quantity}',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    orderItem.date,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(
                      orderItem.isExpanded
                          ? FontAwesomeIcons.chevronUp
                          : FontAwesomeIcons.chevronDown,
                      size: 18.0,
                    ),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false)
                          .toggleExpanded(index);
                    },
                  )
                ],
              ),
              Provider.of<Orders>(context).isExpanded(index)
                  ? CartDropDownItems(
                      cartItems: orderItem.orderedProducts,
                    )
                  : Container(),
              Divider(),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: orderItem.paymentStatus == 'PAID'
                            ? Colors.green[200].withOpacity(0.5)
                            : orderItem.paymentStatus == 'COD'
                                ? Colors.orangeAccent[200].withOpacity(0.5)
                                : Colors.red[200].withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        child: Text(
                          orderItem.paymentStatus,
                          style: TextStyle(
                            color: orderItem.paymentStatus == 'PAID'
                                ? Color(0xFF4BB543)
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    isAllOrders
                        ? ButtonDetails(
                            title: 'Re-order',
                            onTap: () => Navigator.of(context).push(
                              FadePageRoute(
                                childWidget: CartScreen(),
                              ),
                            ),
                          )
                        : ButtonDetails(
                            onTap: () => Navigator.of(context).push(
                              FadePageRoute(
                                childWidget: OrderDetailsScreen(
                                  orderId: orderItem.id,
                                ),
                              ),
                            ),
                            title: 'Details',
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonDetails extends StatelessWidget {
  final String title;
  final Function onTap;

  const ButtonDetails({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
      ),
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6.0,
              vertical: 2.0,
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 5.0),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 12.0,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
