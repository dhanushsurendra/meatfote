import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/orders.dart';
import 'package:meatforte/providers/product.dart';
import 'package:meatforte/widgets/bottom_navigation.dart';
import 'package:meatforte/widgets/button.dart';
import 'package:meatforte/widgets/cart_dropdown_items.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final List<Product> cartItems;
  final String addressId;
  final String title;
  final bool isOrderSummary;

  const OrderDetailsScreen({
    Key key,
    this.orderId,
    this.cartItems,
    this.addressId,
    @required this.title,
    @required this.isOrderSummary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    String _calcTotal() {
      double total = cartItems.fold(0.0, (init, accum) => init += accum.price);
      return total.toStringAsFixed(2);
    }

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

    OrderItem orderItem;
    Address address;

    if (!isOrderSummary) {
      orderItem = Provider.of<Orders>(context, listen: false).getOrder(orderId);
    } else {
      address =
          Provider.of<Addresses>(context, listen: false).getAddress(addressId);
      print(address);
    }

    final List<String> _address = [
      'Business Name',
      'Street Address',
      'Locality',
      'Landmark',
      'City',
      'Pincode',
      'Time of Delivery'
    ];

    final List _values = isOrderSummary
        ? [
            address.businessName,
            address.streetAddress,
            address.locality,
            address.landmark,
            address.city,
            address.pincode.toString(),
            address.timeOfDelivery,
        ]
        : [
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
              title: title,
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
                    isOrderSummary
                        ? Container()
                        : Text(
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
                          'Total:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            isOrderSummary
                                ? Container()
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: orderItem.paymentStatus == 'PAID'
                                          ? Colors.green[200].withOpacity(0.5)
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
                                          color:
                                              orderItem.paymentStatus == 'PAID'
                                                  ? Colors.green[700]
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
                              isOrderSummary
                                  ? _calcTotal()
                                  : orderItem.totalPrice.toStringAsFixed(2),
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
                          isOrderSummary
                              ? DateFormat.yMMMEd().format(
                                  DateTime.now(),
                                )
                              : orderItem.createdAt,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    CartDropDownItems(
                      cartItems: isOrderSummary
                          ? cartItems
                          : orderItem.orderedProducts,
                    ),
                    SizedBox(height: 10.0),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
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
        bottomSheet: isOrderSummary
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Button(
                  onTap: () async {
                    try {
                      await Provider.of<Orders>(context, listen: false)
                          .createOrder(
                        userId,
                        addressId,
                        cartItems,
                        double.parse(_calcTotal()),
                      );

                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.SUCCES,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Successful!',
                        desc: 'Order placed successfully.',
                        showCloseIcon: false,
                        btnOkOnPress: () => Navigator.of(context).push(
                          FadePageRoute(
                            childWidget: BottomNavigation(),
                          ),
                        ),
                        btnOkColor: Theme.of(context).primaryColor,
                        dismissOnBackKeyPress: false,
                        dismissOnTouchOutside: false,
                      )..show();
                    } catch (error) {
                      print(error);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Something went wrong!'),
                        ),
                      );
                    }
                  },
                  buttonText: 'Confirm',
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
