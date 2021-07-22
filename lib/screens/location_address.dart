import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/widgets/button.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class LocationAddress extends StatefulWidget {
  final String address;
  final double latitude;
  final double longitude;

  LocationAddress({
    Key key,
    @required this.address,
    @required this.latitude,
    @required this.longitude,
  }) : super(key: key);

  @override
  _LocationAddressState createState() => _LocationAddressState();
}

class _LocationAddressState extends State<LocationAddress> {

  String _selectedDropDownValue = '6 AM';
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  TextEditingController _businessNameController;
  TextEditingController _phoneNumberController;
  TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController(text: '');
    _addressController = TextEditingController(text: widget.address);
    _phoneNumberController = TextEditingController(text: '');
  }

  final FocusNode _businessNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _businessNameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _addressFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.address);
    Future<void> _formValidate() async {
      final isValid = _formKey.currentState.validate();
      if (!isValid) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> _address = {
        'userId': Provider.of<Auth>(context, listen: false).userId,
        'businessName': _businessNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'address': widget.address,
        'timeOfDelivery': _selectedDropDownValue,
        'latitude': widget.latitude,
        'longitude': widget.longitude,
      };

      FocusScope.of(context).unfocus();

      try {
        await Provider.of<Addresses>(context, listen: false)
            .addAddress(_address);

        setState(() {
          _isLoading = false;
        });

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
      } on HttpException catch (error) {
        print(error);
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong.'),
          ),
        );
      } catch (error) {
        print(error);
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

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            flexibleSpace: CustomAppBar(
              title: 'Location Address',
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
                      FontHeading(text: 'Address'),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.multiline,
                        minLines: 1, //Normal textInputField will be displayed
                        maxLines: 5,
                        cursorColor: Theme.of(context).primaryColor,
                        focusNode: _addressFocusNode,
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
                      ),
                      SizedBox(
                        height: 10.0,
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
                                FocusScope.of(context).unfocus();
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
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              value: _selectedDropDownValue,
                            ),
                          ],
                        ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
