import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/screens/manage_address_screen.dart';
import 'package:meatforte/widgets/button.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final String title;
  final Address address;
  final String buttonText;

  const CheckoutScreen({
    Key key,
    @required this.title,
    @required this.address,
    @required this.buttonText,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedDropDownValue = '6 AM';

  TextEditingController _businessNameController =
      TextEditingController(text: '');
  TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  TextEditingController _streetAddressController =
      TextEditingController(text: '');
  TextEditingController _localityController = TextEditingController(text: '');
  TextEditingController _landmarkController = TextEditingController(text: '');
  TextEditingController _cityController = TextEditingController(text: '');
  TextEditingController _pincodeController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _businessNameController =
          TextEditingController(text: widget.address.businessName);
      _phoneNumberController =
          TextEditingController(text: widget.address.phoneNumber.split(' ')[1]);
      _streetAddressController =
          TextEditingController(text: widget.address.streetAddress);
      _localityController =
          TextEditingController(text: widget.address.locality);
      _landmarkController =
          TextEditingController(text: widget.address.landmark);
      _cityController = TextEditingController(text: widget.address.city);
      _pincodeController =
          TextEditingController(text: widget.address.pincode.toString());
      _selectedDropDownValue = widget.address.timeOfDelivery;
    }
  }

  Future<void> _formValidate() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    Map<String, dynamic> _address = {
      'userId': Provider.of<Auth>(context, listen: false).userId,
      'businessName': _businessNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'streetAddress': _streetAddressController.text,
      'locality': _localityController.text,
      'city': _cityController.text,
      'landmark': _landmarkController.text,
      'pincode': int.parse(_pincodeController.text),
      'timeOfDelivery': _selectedDropDownValue,
    };

    FocusScope.of(context).unfocus();

    try {
      if (widget.title == 'Add Address') {
        await Provider.of<Addresses>(context, listen: false)
            .addOrUpdateAddress(_address, 'ADD');

        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Successful!',
          desc: 'Address added successfully.',
          showCloseIcon: false,
          btnOkOnPress: () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: ManageAddressScreen(
                type: 'SELECT',
                title: 'Select Address',
              ),
            ),
          ),
          btnOkColor: Theme.of(context).primaryColor,
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
        )..show();
      } else if (widget.title == 'Edit Address') {
        await Provider.of<Addresses>(context, listen: false).addOrUpdateAddress(
          {
            'addressId': widget.address.id,
            ..._address,
          },
          'UPDATE',
        );

        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Successful',
          desc: 'Address updated successfully.',
          showCloseIcon: false,
          btnOkOnPress: () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: ManageAddressScreen(
                type: 'SELECT',
                title: 'Select Address',
              ),
            ),
          ),
          btnOkColor: Theme.of(context).primaryColor,
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
        )..show();
      }
    } on HttpException catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong.'),
        ),
      );
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong.'),
        ),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  final FocusNode _businessNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _streetAddressFocusNode = FocusNode();
  final FocusNode _localityFocusNode = FocusNode();
  final FocusNode _landmarkFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _pincodeFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _businessNameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _streetAddressFocusNode.dispose();
    _localityFocusNode.dispose();
    _landmarkFocusNode.dispose();
    _cityFocusNode.dispose();
    _pincodeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.address);

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
              title: widget.title,
              containsBackButton: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
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
                                textInputAction: TextInputAction.next,
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
                        focusNode: _streetAddressFocusNode,
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
                        controller: _streetAddressController,
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
                      FontHeading(text: 'Locality'),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        focusNode: _localityFocusNode,
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
                        controller: _localityController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid locality';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FontHeading(text: 'Landmark'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  cursorColor: Theme.of(context).primaryColor,
                                  focusNode: _landmarkFocusNode,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 9.5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    fillColor:
                                        Color(0xFFCAD1DB).withOpacity(.45),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                  controller: _landmarkController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a valid landmark';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FontHeading(text: 'City'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  cursorColor: Theme.of(context).primaryColor,
                                  focusNode: _cityFocusNode,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    fillColor:
                                        Color(0xFFCAD1DB).withOpacity(.45),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                  controller: _cityController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a valid city';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FontHeading(text: 'Pincode'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  cursorColor: Theme.of(context).primaryColor,
                                  focusNode: _pincodeFocusNode,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    fillColor:
                                        Color(0xFFCAD1DB).withOpacity(.45),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                  controller: _pincodeController,
                                  validator: (value) {
                                    if (value.isEmpty ||
                                        value.length < 6 ||
                                        value.length > 6) {
                                      return 'Please enter a valid pincode';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FontHeading(text: 'Time of Delivery'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                DropdownButton<String>(
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
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Button(
                        buttonText: widget.buttonText,
                        onTap: _formValidate,
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
