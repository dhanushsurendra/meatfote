import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/user.dart';
import 'package:meatforte/screens/business_details_verification_screen.dart';
import 'package:meatforte/screens/user_details_verification_screen.dart';
import 'package:meatforte/widgets/list_tile_container.dart';
import 'package:meatforte/widgets/profile_image.dart';
import 'package:provider/provider.dart';

class PersonalDetails extends StatefulWidget {
  final Key key;
  final String buttonText;
  final bool inApp;

  PersonalDetails({
    this.key,
    this.buttonText = 'Update',
    @required this.inApp,
  });

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _phoneNumberController = TextEditingController(text: '');

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  String userId;
  bool _isLoading = false;
  bool _isFirstTime = true;

  @override
  void dispose() {
    super.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();

    userId = Provider.of<Auth>(context, listen: false).userId;

    Future.delayed(Duration.zero).then((value) async {
      try {
        await Provider.of<User>(context, listen: false)
            .getUserPersonalDetails(context, userId);
      } catch (error) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error!',
          desc: 'Something went wrong',
          btnOkOnPress: () => Navigator.of(context).pop(),
          btnOkColor: Theme.of(context).primaryColor,
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
        )..show();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstTime) {
      var provider = Provider.of<User>(context);

      if (provider.userName != '' || provider.userName != null) {
        _nameController.text = provider.userName;
      }

      if (provider.userEmail != '' || provider.userEmail != null) {
        _emailController.text = provider.userEmail;
      }

      if (provider.userPhoneNumber != '' || provider.userPhoneNumber != null) {
        _phoneNumberController.text = provider.userPhoneNumber;
      }
    }

    _isFirstTime = false;
  }

  Future<void> _onFormSubmitted() async {
    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<User>(context, listen: false).postUserPersonalDetails(
        context,
        _nameController.text,
        userId,
        _emailController.text,
        _phoneNumberController.text,
      );

      setState(() {
        _isLoading = false;
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Success',
        desc: 'Personal details successfully updated.',
        btnOkOnPress: () => widget.inApp
            ? {}
            : Navigator.of(context).push(
                FadePageRoute(
                  childWidget: BusinessDetailsVerificationScreen(),
                ),
              ),
        btnOkColor: Theme.of(context).primaryColor,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
      )..show();
    } on HttpException catch (error) {
      setState(() {
        _isLoading = false;
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error!',
        desc: error.toString() != null
            ? error
                    .toString()
                    .startsWith('Personal verification document not added')
                ? error.toString()
                : 'Something went wrong!'
            : 'Something went wrong',
        btnOkOnPress: () => {},
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error!',
        desc: 'Something went wrong.',
        btnOkOnPress: () => {},
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    _showModalBottomSheet() {
      final _listItems = [
        'Aadhar Card',
        'Pan Card',
        'Voter Id',
        'Driver\'s License',
      ];

      return showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: _listItems.length * 60.0 + 60.0,
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Text(
                  'Select any one',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _listItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          _listItems[index],
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            FadePageRoute(
                              childWidget: UserDetailsVerificationScreen(
                                document: _listItems[index],
                                title: 'Personal Verification',
                                documentType: 'personal',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
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
                  enabled: !widget.inApp
                      ? true
                      : Provider.of<User>(context).userIdentifier != 'EMAIL',
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
                  enabled: !widget.inApp
                      ? true
                      : Provider.of<User>(context).userIdentifier !=
                          'PHONE_NUMBER',
                  focusNode: _phoneNumberFocusNode,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.phone,
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    prefixText: '+91 ',
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
                  title:
                      'Get verified to avail loans / credits on your purchase',
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    return _showModalBottomSheet();
                  },
                  icon: Icon(Icons.security),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 30.0),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Material(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      onTap: _onFormSubmitted,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: Center(
                          child: _isLoading
                              ? SizedBox(
                                  width: 25.0,
                                  height: 25.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  widget.buttonText,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    color: Colors.transparent,
                  ),
                ),
                SizedBox(height: 30.0)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
