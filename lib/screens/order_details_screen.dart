import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meatforte/providers/orders.dart';
import 'package:meatforte/widgets/cart_dropdown_items.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({
    Key key,
    this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildAddress(String item, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
          ],
        ),
      );
    }

    final OrderItem orderItem =
        Provider.of<Orders>(context, listen: false).getOrder('1');

    final List<String> _address = [
      'Business Name',
      'Street Address',
      'Locality',
      'Landmark',
      'City',
      'Pincode',
      'Time of Delivery'
    ];
    final List _values = [
      orderItem.address.businessName,
      orderItem.address.streetAddress,
      orderItem.address.locality,
      orderItem.address.landmark,
      orderItem.address.city,
      orderItem.address.pincode.toString(),
      orderItem.address.timeOfDelivery,
    ];

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            flexibleSpace: CustomAppBar(
              title: 'Order Detail',
              containsBackButton: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Id: ${orderItem.id}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity: ${orderItem.quantity}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: orderItem.paymentStatus == 'PAID'
                                    ? Colors.green[200].withOpacity(0.5)
                                    : orderItem.paymentStatus == 'COD'
                                        ? Colors.orangeAccent[200]
                                            .withOpacity(0.5)
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
                                        ? Colors.green[700]
                                        : orderItem.paymentStatus == 'COD'
                                            ? Colors.orangeAccent[700]
                                            : Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
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
                    SizedBox(height: 10.0),
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
                      ],
                    ),
                    CartDropDownItems(
                      cartItems: orderItem.orderedProducts,
                    ),
                    Divider(),
                    ..._address
                        .asMap()
                        .map(
                          (key, value) => MapEntry(
                            key,
                            _buildAddress(
                              value,
                              _values[key],
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
