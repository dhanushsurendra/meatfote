import 'package:flutter/material.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/helpers/modal_bottom_sheet.dart';
import 'package:meatforte/widgets/list_tile_container.dart';
import 'package:meatforte/widgets/profile_image.dart';

import 'button.dart';

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
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
              FontHeading(text: 'Name'),
              SizedBox(height: 10.0),
              TextFormField(
                cursorColor: Theme.of(context).primaryColor,
                controller: _nameController,
                focusNode: _nameFocusNode,
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
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                validator: (value) {
                  if (value.length <= 3) {
                    return 'Name should be greater than 3 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              FontHeading(text: 'Email'),
              SizedBox(height: 10.0),
              TextFormField(
                cursorColor: Theme.of(context).primaryColor,
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Color(0xFFCAD1DB).withOpacity(.45),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 10.0,
                  ),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
                },
                validator: (value) {
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Invalid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              FontHeading(text: 'Phone Number'),
              SizedBox(height: 10.0),
              TextFormField(
                focusNode: _phoneNumberFocusNode,
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.phone,
                controller: _phoneNumberController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixText: '+91',
                  prefixStyle: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Color(0xFFCAD1DB).withOpacity(.45),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 10.0,
                  ),
                ),
                onFieldSubmitted: (_) => _onFormSubmitted(),
                validator: (value) {
                  if (value.length < 10 || value.isEmpty) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              FontHeading(text: 'Personal Verification'),
              SizedBox(height: 10.0),
              ListTileContainer(
                letterSpacing: 0.0,
                title: 'Get verified to avail loans / credits on your purchase',
                onTap: () {
                  FocusScope.of(context).unfocus();
                  ModalBottomSheet.modalBottomSheet(
                    context,
                    [
                      'Aadhar Card',
                      'Pan Card',
                      'Voter Id',
                      'Driver\'s License'
                    ],
                    'Select any one',
                  );
                },
                icon: Icon(Icons.security),
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 30.0),
              Button(
                onTap: () => _onFormSubmitted(),
                buttonText: 'Update',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
