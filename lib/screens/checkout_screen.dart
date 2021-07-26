import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedDropDownValue = '6 AM';
  GoogleMapController controller;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _pickedLocation;
  var _address;
  var _coordinates;
  bool _isLoading = false;

  TextEditingController _businessNameController =
      TextEditingController(text: '');
  TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  TextEditingController _addressController = TextEditingController(text: '');

  Map<String, double> _userLocation = {
    'latitude': 0.0,
    'longitude': 0.0,
  };

  final _formKey = GlobalKey<FormState>();

  final FocusNode _businessNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Future<void> _getUserCurrentLocation() async {
      try {
        final locData = await Location.instance.getLocation();
        setState(() {
          _userLocation.update('latitude', (value) => locData.latitude);
          _userLocation.update('longitude', (value) => locData.longitude);
        });

        final CameraPosition _userLocationCameraPosition = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(
            locData.latitude,
            locData.longitude,
          ),
          tilt: 59.440717697143555,
          zoom: 19.151926040649414,
        );

        controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(_userLocationCameraPosition),
        );

        setState(() {
          _pickedLocation = LatLng(locData.latitude, locData.longitude);
        });

        _coordinates = new Coordinates(locData.latitude, locData.longitude);

        _address =
            await Geocoder.local.findAddressesFromCoordinates(_coordinates);

        _addressController.text = _address[0].addressLine;
      } catch (error) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error',
          desc: 'Something went wrong!',
          btnOkOnPress: () => Navigator.of(context).pop(),
          btnOkColor: Theme.of(context).primaryColor,
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
        )..show();
      }
    }

    _getUserCurrentLocation();
  }

  Future<void> _formValidate() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    FocusScope.of(context).unfocus();

    if (!_addressController.text.toLowerCase().contains('bengaluru')) {
      if (_addressController.text.toLowerCase().contains('bangalore')) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error',
          desc: 'We do not operate at your location.',
          btnOkOnPress: () {},
          btnOkColor: Theme.of(context).primaryColor,
        )..show();

        setState(() {
          _isLoading = false;
        });

        return;
      }
    }

    Map<String, dynamic> _address = {
      'userId': Provider.of<Auth>(context, listen: false).userId,
      'businessName': _businessNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'address': _addressController.text,
      'timeOfDelivery': _selectedDropDownValue,
      'latitude': _pickedLocation.latitude,
      'longitude': _pickedLocation.longitude,
    };

    try {
      await Provider.of<Addresses>(context, listen: false).addAddress(_address);

      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Successful!',
        desc: 'Address added successfully.',
        btnOkOnPress: () => Navigator.of(context).pop(),
        btnOkColor: Theme.of(context).primaryColor,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
      )..show();

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong.'),
        ),
      );
    }
  }

  void _selectLocation(LatLng position) async {
    final CameraPosition _userLocationCameraPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(
        position.latitude,
        position.longitude,
      ),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
    );

    controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_userLocationCameraPosition),
    );

    setState(() {
      _pickedLocation = position;
    });

    _coordinates = new Coordinates(position.latitude, position.longitude);
    _address = await Geocoder.local.findAddressesFromCoordinates(_coordinates);

    setState(() {
      _addressController.text = _address[0].addressLine;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _businessNameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _addressFocusNode.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
      void _unfocusFields() {
        FocusScope.of(context).unfocus();
      }

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            flexibleSpace: CustomAppBar(
              title: 'Add Address',
              containsBackButton: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    )
                  ].toSet(),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(12.9797, 77.5912),
                    zoom: 16,
                    tilt: 59.440717697143555,
                    bearing: 192.8334901395799,
                  ),
                  onTap: _selectLocation,
                  markers: {
                    Marker(
                      markerId: MarkerId('m1'),
                      infoWindow: InfoWindow(
                        title: 'Your Location',
                      ),
                      position: _pickedLocation ??
                          LatLng(
                            _userLocation['latitude'],
                            _userLocation['longitude'],
                          ),
                    )
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);

                    controller.setMapStyle(Utils.mapStyle);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 20.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FontHeading(text: 'Business Name'),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        focusNode: _businessNameFocusNode,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          fillColor: Color(0xFFCAD1DB).withOpacity(.45),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 10.0,
                          ),
                        ),
                        controller: _businessNameController,
                        validator: (value) {
                          if (value.isEmpty || value.length < 3) {
                            return 'Shop name should be at least 3 characteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FontHeading(text: 'Phone Number'),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFCAD1DB).withOpacity(.45),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Text(
                                  '+91',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                cursorColor: Theme.of(context).primaryColor,
                                focusNode: _phoneNumberFocusNode,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  fillColor: Color(0xFFCAD1DB).withOpacity(.45),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal: 10.0,
                                  ),
                                ),
                                controller: _phoneNumberController,
                                validator: (value) {
                                  if (value.length < 10 || value.isEmpty) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FontHeading(text: 'Street Address'),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        focusNode: _addressFocusNode,
                        keyboardType: TextInputType.multiline,
                        minLines: 1, //Normal textInputField will be displayed
                        maxLines: 20,
                        enabled: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          fillColor: Color(0xFFCAD1DB).withOpacity(.45),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                        ),
                        controller: _addressController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid street address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FontHeading(text: 'Time of Delivery'),
                          SizedBox(
                            height: 10.0,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            onTap: () {
                              _unfocusFields();
                            },
                            items: <String>[
                              '6 AM',
                              '7 AM',
                              '8 AM',
                              '9 AM',
                              '10 AM',
                              '12 PM',
                              '1 PM',
                              '2 PM'
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDropDownValue = value;
                                _unfocusFields();
                              });
                            },
                            value: _selectedDropDownValue,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Material(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(5.0),
                            onTap: _formValidate,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              child: Center(
                                child: !_isLoading
                                    ? Text(
                                        'Add address',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : SizedBox(
                                        width: 25.0,
                                        height: 25.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
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

class Utils {
  static String mapStyle = '''
  [  
      {
      "featureType": "administrative",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#d6e2e6"
        }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#cfd4d5"
        }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#7492a8"
        }
      ]
    },
    {
      "featureType": "administrative.neighborhood",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "lightness": 25
        }
      ]
    },
    {
      "featureType": "landscape.man_made",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#dde2e3"
        }
      ]
    },
    {
      "featureType": "landscape.man_made",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#cfd4d5"
        }
      ]
    },
    {
      "featureType": "landscape.natural",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#dde2e3"
        }
      ]
    },
    {
      "featureType": "landscape.natural",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#7492a8"
        }
      ]
    },
    {
      "featureType": "landscape.natural.terrain",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#dde2e3"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.icon",
      "stylers": [
        {
          "saturation": -100
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#588ca4"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#a9de83"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#bae6a1"
        }
      ]
    },
    {
      "featureType": "poi.sports_complex",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#c6e8b3"
        }
      ]
    },
    {
      "featureType": "poi.sports_complex",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#bae6a1"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.icon",
      "stylers": [
        {
          "saturation": -45
        },
        {
          "lightness": 10
        },
        {
          "visibility": "on"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#41626b"
        }
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#c1d1d6"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#a6b5bb"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "on"
        }
      ]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#9fb6bd"
        }
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.icon",
      "stylers": [
        {
          "saturation": -70
        }
      ]
    },
    {
      "featureType": "transit.line",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#b4cbd4"
        }
      ]
    },
    {
      "featureType": "transit.line",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#588ca4"
        }
      ]
    },
    {
      "featureType": "transit.station",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#008cb5"
        }
      ]
    },
    {
      "featureType": "transit.station.airport",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "saturation": -100
        },
        {
          "lightness": -5
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#a6cbe3"
        }
      ]
    }
  ]
  ''';
}
