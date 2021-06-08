import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/cart.dart';
import 'package:meatforte/screens/checkout_screen.dart';
import 'package:meatforte/screens/order_details_screen.dart';
import 'package:meatforte/widgets/address_item.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/empty_image.dart';
import 'package:meatforte/widgets/error_handler.dart';
import 'package:meatforte/widgets/radio_address.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
    String userId = Provider.of<Auth>(context, listen: false).userId;
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {});
    });
    Provider.of<Addresses>(context, listen: false).getAddresses(userId);
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> _getAddresses(String userId) async {
    await Provider.of<Addresses>(context, listen: false).getAddresses(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            flexibleSpace: CustomAppBar(
              title: widget.title,
              containsBackButton: true,
            ),
          ),
        ),
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

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 200.0,
                          color: Colors.grey[300],
                        ),
                      );
                    },
                  ),
                ),
              );
            }

            return Provider.of<Addresses>(context).addresses.length == 0
                ? EmptyImage(
                    message: 'No addresses yet. Add a new one!',
                    imageUrl: 'assets/images/empty.png',
                    heightPercent: 0.8,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 16.0,
                        ),
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
                      widget.title == 'Select Address'
                          ? RadioListBuilder()
                          : Expanded(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: Provider.of<Addresses>(
                                  context,
                                ).addresses.length,
                                itemBuilder: (context, index) {
                                  final Address address =
                                      Provider.of<Addresses>(context)
                                          .addresses[index];
                                  if (index ==
                                      Provider.of<Addresses>(context)
                                              .addresses
                                              .length -
                                          1) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child:
                                          AddressItemBuilder(address: address),
                                    );
                                  }
                                  return AddressItemBuilder(address: address);
                                },
                              ),
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

class AddressItemBuilder extends StatelessWidget {
  final Address address;

  const AddressItemBuilder({
    Key key,
    @required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddressItem(address: address);
  }
}

class RadioListBuilder extends StatefulWidget {
  RadioListBuilder({Key key}) : super(key: key);

  @override
  _RadioListBuilderState createState() => _RadioListBuilderState();
}

class _RadioListBuilderState extends State<RadioListBuilder> {
  int value = 0;

  void _onRadioChanged(int newValue) {
    setState(
      () {
        value = newValue;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final Address address =
              Provider.of<Addresses>(context).addresses[index];
          if (index == Provider.of<Addresses>(context).addresses.length - 1) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RadioAddress(
                address: address,
                index: index,
                value: value,
                onTap: _onRadioChanged,
              ),
            );
          }
          return RadioAddress(
            address: address,
            index: index,
            value: value,
            onTap: (int value) {
              _onRadioChanged(value);
            },
          );
        },
        itemCount: Provider.of<Addresses>(context).addresses.length,
      ),
    );
  }
}
