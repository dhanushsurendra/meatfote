import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/cart.dart';
import 'package:meatforte/screens/order_details_screen.dart';
import 'package:provider/provider.dart';

class SelectAddressItem extends StatelessWidget {
  final Address address;
  final bool isOrderSummary;

  const SelectAddressItem({
    Key key,
    @required this.address,
    @required this.isOrderSummary,
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
        padding: isOrderSummary
            ? EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)
            : EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              child: Row(
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
                          '${address.address}',
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.0),
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
                        SizedBox(height: 5.0),
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
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
