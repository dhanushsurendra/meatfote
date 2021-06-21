import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/cart.dart';
import 'package:meatforte/screens/manage_address_screen.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  final double height;

  const BottomBar({
    Key key,
    this.height = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AwesomeDialog _showDialog() {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Out of Stock',
        desc:
            'One or more products are not in stock. Sorry for the inconvenience.',
        showCloseIcon: false,
        btnOkOnPress: () => {},
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, -2.0),
              blurRadius: 6.0,
              color: Colors.black12,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.rupeeSign,
                        color: Colors.white,
                        size: 12.0,
                      ),
                      Text(
                        Provider.of<Cart>(context).total.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: 35.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    child: InkWell(
                      onTap: () => !Provider.of<Cart>(context, listen: false)
                              .isCartItemsInStock
                          ? _showDialog()
                          : Provider.of<Cart>(context, listen: false)
                                      .cartItems
                                      .length ==
                                  0
                              ? null
                              : Navigator.of(context).push(
                                  FadePageRoute(
                                    childWidget: ManageAddressScreen(
                                      type: 'SELECT',
                                      title: 'Select Address',
                                    ),
                                  ),
                                ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
