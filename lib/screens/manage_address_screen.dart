import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as GeoLoc;
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/screens/checkout_screen.dart';
import 'package:meatforte/screens/location_address.dart';
import 'package:meatforte/widgets/address_item.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/empty_image.dart';
import 'package:meatforte/widgets/error_handler.dart';
import 'package:meatforte/widgets/select_address_item.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:meatforte/providers/addresses.dart' as Modal;

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
    await Provider.of<Addresses>(context, listen: false).getAddresses(userId);
    setState(() {});
  }

  Future<void> _detectLocation() async {
    bool serviceEnabled;
    GeoLoc.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await GeoLoc.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error!',
        desc: 'Location services are not enabled. Enable it to continue.',
        btnOkOnPress: () => {},
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
      return;
    }

    permission = await GeoLoc.Geolocator.checkPermission();
    if (permission == GeoLoc.LocationPermission.denied) {
      permission = await GeoLoc.Geolocator.requestPermission();
      if (permission == GeoLoc.LocationPermission.denied) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error!',
          desc: 'Permission denied. Enable it to detect location.',
          btnOkOnPress: () => {},
          btnOkColor: Theme.of(context).primaryColor,
        )..show();
        return;
      }
    }

    if (permission == GeoLoc.LocationPermission.deniedForever) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error!',
        desc: 'Permission denied for this app. Enable it in settings.',
        btnOkOnPress: () => {},
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    GeoLoc.Position position = await GeoLoc.Geolocator.getCurrentPosition(
      desiredAccuracy: GeoLoc.LocationAccuracy.best,
    );

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    if (!address[0].addressLine.contains('Bengaluru')) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error!',
        desc:
            'Sorry, we currrently don\'t operate at your location. Coming soon!',
        btnOkOnPress: () => {},
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
    } else {
      Navigator.of(context).push(
        FadePageRoute(
          childWidget: LocationAddress(
            address: address[0].addressLine,
            latitude: address[0].coordinates.latitude,
            longitude: address[0].coordinates.longitude,
          ),
        ),
      );
    }
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
                color: Theme.of(context).primaryColor,
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
                          ? Expanded(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: Provider.of<Addresses>(context)
                                    .addresses
                                    .length,
                                itemBuilder: (BuildContext context, int index) {
                                  final Modal.Address address =
                                      Provider.of<Addresses>(context)
                                          .addresses[index];
                                  return SelectAddressItem(
                                    address: address,
                                    isOrderSummary: true,
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: Provider.of<Addresses>(
                                  context,
                                ).addresses.length,
                                itemBuilder: (context, index) {
                                  final Modal.Address address =
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
            Icons.location_on,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            showModalBottomSheet<dynamic>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                  height: 180.0,
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        'Select',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await _detectLocation();
                        },
                        leading: Icon(Icons.location_on),
                        title: Text(
                          'Current Location',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          Navigator.of(context).pop();

                          Navigator.of(context).push(
                            FadePageRoute(
                              childWidget: CheckoutScreen(),
                            ),
                          );
                        },
                        leading: Icon(Icons.map),
                        title: Text(
                          'Select on Map',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AddressItemBuilder extends StatelessWidget {
  final Modal.Address address;

  const AddressItemBuilder({
    Key key,
    @required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddressItem(address: address);
  }
}
