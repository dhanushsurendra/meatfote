import 'package:flutter/material.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/helpers/modal_bottom_sheet.dart';
import 'package:meatforte/widgets/list_tile_container.dart';
import 'package:meatforte/widgets/profile_image.dart';

import 'button.dart';

class BusinessDetails extends StatefulWidget {
  @override
  _BusinessDetailsState createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  final _formKey = GlobalKey<FormState>();

  final _shopNameController = TextEditingController();
  final _establishmentYearController = TextEditingController();

  final FocusNode _shopNameFocusNode = FocusNode();
  final FocusNode _establishmentYearFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _shopNameFocusNode.dispose();
    _establishmentYearFocusNode.dispose();
  }

  Future<void> _onFormSubmitted() {
    bool isValid = _formKey.currentState.validate();
    print(isValid);
    if (!isValid) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileImage(),
        SizedBox(height: 20.0),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FontHeading(text: 'Shop Name'),
              SizedBox(height: 10.0),
              TextFormField(
                cursorColor: Theme.of(context).primaryColor,
                controller: _shopNameController,
                focusNode: _shopNameFocusNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: BorderSide.none,
                  ),
                  errorMaxLines: 2,
                  fillColor: Color(0xFFCAD1DB).withOpacity(.45),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 10.0,
                  ),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context)
                      .requestFocus(_establishmentYearFocusNode);
                },
                validator: (value) {
                  if (value.length <= 3) {
                    return 'Name should be greater than 3 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              FontHeading(text: 'Business Verification'),
              SizedBox(height: 10.0),
              ListTileContainer(
                title:
                    'Get your business verified to get the verified business badge',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w400,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  ModalBottomSheet.modalBottomSheet(
                    context,
                    [
                      'GST Certificate',
                      'Udyam Aadhar',
                      'Shop & Establishment License',
                      'Trade Certificate / Licencse',
                      'FSSAI Registration',
                      'Current Account Check',
                    ],
                    'Select any one',
                  );
                },
                icon: Icon(Icons.security_outlined),
                fontSize: 12.0,
              ),
              SizedBox(height: 10.0),
              FontHeading(text: 'Business Type'),
              SizedBox(height: 10.0),
              ListTileContainer(
                title: 'Select Business Type',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w400,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  ModalBottomSheet.modalBottomSheet(
                    context,
                    [
                      'Fine Dinning',
                      'Quick Service Resturants',
                      'Events Management',
                      'Cloud Kitchen',
                      'Institutions',
                      'Food Caterers',
                      'Food Truck',
                      'Food Processors'
                    ],
                    'Select any one',
                    true,
                    true,
                  );
                },
                icon: Icon(Icons.business_center_outlined),
                fontSize: 12.0,
              ),
              SizedBox(height: 10.0),
              FontHeading(text: 'Establishment Year'),
              SizedBox(height: 10.0),
              TextFormField(
                cursorColor: Theme.of(context).primaryColor,
                controller: _establishmentYearController,
                focusNode: _establishmentYearFocusNode,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.date_range_outlined),
                  errorMaxLines: 2,
                  fillColor: Color(0xFFCAD1DB).withOpacity(.45),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 10.0,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty ||
                      value.length != 4 ||
                      (int.parse(value) >= 1800 &&
                          int.parse(value) <= DateTime.now().year)) {
                    return 'Establishment year should be between 1800 and ${DateTime.now().year}';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.0),
              Button(
                onTap: () => _onFormSubmitted(),
                buttonText: 'Update',
              )
            ],
          ),
        ),
      ],
    );
  }
}
