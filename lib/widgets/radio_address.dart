import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/cart.dart';
import 'package:meatforte/screens/checkout_screen.dart';
import 'package:meatforte/screens/order_details_screen.dart';
import 'package:provider/provider.dart';

class RadioAddress extends StatelessWidget {
  final Address address;
  final int index;
  final int value;
  final Function onTap;

  const RadioAddress({
    Key key,
    @required this.address,
    @required this.index,
    @required this.value,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          FadePageRoute(
            childWidget: OrderDetailsScreen(
              title: 'Order Summary',
              isOrderSummary: true,
              hasCancelOrder: false,
              addressId: address.id,
              cartItems: Provider.of<Cart>(context, listen: false).cartItems,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0,
                color: Colors.black12,
              ),
            ],
          ),
          child: RadioListTile(
            value: index,
            groupValue: value,
            onChanged: (value) {
              Navigator.of(context).push(
                FadePageRoute(
                  childWidget: OrderDetailsScreen(
                    title: 'Order Summary',
                    isOrderSummary: true,
                    addressId: address.id,
                    hasCancelOrder: false,
                    cartItems:
                        Provider.of<Cart>(context, listen: false).cartItems,
                  ),
                ),
              );
              onTap(value);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${address.businessName}',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Street: ${address.streetAddress}',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Locality: ${address.locality}',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Landmark: ${address.landmark}',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'City: ${address.city} - ${address.pincode.toString()}',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Time of Delivery: ${address.timeOfDelivery}',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Contact: ${address.phoneNumber}',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      FadePageRoute(
                        childWidget: CheckoutScreen(
                          title: 'Edit Address',
                          address: Provider.of<Addresses>(
                            context,
                            listen: false,
                          ).getAddress(address.id),
                          buttonText: 'Continue',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 35.0,
                    height: 35.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Color(0xFFEBEBF1),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 22.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
