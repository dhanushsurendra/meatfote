import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/cart.dart';
import 'package:meatforte/screens/checkout_screen.dart';
import 'package:meatforte/widgets/address_item.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/error_handler.dart';
import 'package:provider/provider.dart';

class ManageAddressScreen extends StatefulWidget {
  final String type;
  final String title;

  ManageAddressScreen({
    Key key,
    @required this.title,
    @required this.type,
  }) : super(key: key);

  @override
  _ManageAddressScreenState createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> _getAddresses(String userId) async {
    await Provider.of<Cart>(context, listen: false).getCartItems(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: Provider.of<Addresses>(context, listen: false)
              .getAddresses(userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return RefreshIndicator(
                onRefresh: () => _getAddresses(userId),
                child: ErrorHandler(
                  message: 'Something went wrong. Please try again.',
                  heightPercent: .96,
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {}

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: widget.title,
                  containsBackButton: true,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Container(
                    width: double.infinity,
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
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        '${Provider.of<Addresses>(context, listen: false).addresses.length} Address found',
                        softWrap: false,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FontHeading(text: 'Shop Addresses'),
                ),
                SizedBox(height: 10.0),
                AddressItem(
                  type: widget.type,
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          isExtended: true,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: CheckoutScreen(
                title: 'Add Address',
                address: null,
                buttonText: 'Continue',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
