import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/user.dart';
import 'package:meatforte/screens/pending_verification_screen.dart';
import 'package:meatforte/screens/user_details_verification_screen.dart';
import 'package:meatforte/widgets/list_tile_container.dart';
import 'package:provider/provider.dart';

class BusinessDetails extends StatefulWidget {
  final String buttonText;

  const BusinessDetails({
    Key key,
    this.buttonText = 'Update',
  }) : super(key: key);

  @override
  _BusinessDetailsState createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  String _businessType;

  final _formKey = GlobalKey<FormState>();

  final _shopNameController = TextEditingController();
  final _establishmentYearController = TextEditingController();

  final FocusNode _shopNameFocusNode = FocusNode();
  final FocusNode _establishmentYearFocusNode = FocusNode();

  String userId;

  bool _isLoading = false;
  var provider;

  @override
  void initState() {
    super.initState();

    userId = Provider.of<Auth>(context, listen: false).userId;

    if (userId != null) {
      Future.delayed(Duration.zero).then(
        (value) async => await Provider.of<User>(context, listen: false)
            .getUserBusinessDetails(userId),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<User>(context);

    if (provider.userBusinessType == '' || provider.userBusinessType == null) {
      _businessType = 'Select business type';
    } else {
      setState(() {
        _businessType = provider.userBusinessType;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _shopNameFocusNode.dispose();
    _establishmentYearFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (provider.userBusinessName != '' || provider.userBusinessName != null) {
      _shopNameController.text = provider.userBusinessName;
    }

    if (provider.userEstablishmentYear != '' ||
        provider.userEstablishmentYear != null) {
      _establishmentYearController.text = provider.userEstablishmentYear;
    }

    Future<void> _onFormSubmitted() async {
      bool isValid = _formKey.currentState.validate();
      if (!isValid) {
        return;
      }

      if (_businessType == 'Select business type') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Select business type'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      FocusScope.of(context).unfocus();

      try {
        await Provider.of<User>(context, listen: false).postUserBusinessDetails(
          _shopNameController.text,
          _businessType,
          userId,
          _establishmentYearController.text,
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
          showCloseIcon: false,
          btnOkOnPress: () => {},
          // Navigator.of(context).push(
          //   FadePageRoute(
          //     childWidget: PendingVerificationScreen(),
          //   ),
          // ),
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
          showCloseIcon: false,
          btnOkOnPress: () => {},
          btnOkColor: Theme.of(context).primaryColor,
        )..show();
      }
    }

    _showModalBottomSheet(String type) {
      final _businessTypeList = [
        'Fine Dinning',
        'Quick Service Resturants',
        'Events Management',
        'Cloud Kitchen',
        'Institutions',
        'Food Caterers',
        'Food Truck',
        'Food Processors'
      ];

      final _businessVerificationList = [
        'GST Certificate',
        'Udyam Aadhar',
        'Shop & Establishment License',
        'Trade Certificate / Licencse',
        'FSSAI Registration',
        'Current Account Check',
      ];

      return showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: type == 'business_type'
                ? _businessTypeList.length * 60.0 + 50.0
                : _businessVerificationList.length * 60.0 + 50.0,
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
                    itemCount: type == 'business_type'
                        ? _businessTypeList.length
                        : _businessVerificationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          type == 'business_type'
                        ? _businessTypeList[index]
                        : _businessVerificationList[index],
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          if (type == 'business_type') {
                            setState(() {
                              _businessType = _businessTypeList[index];
                            });
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              FadePageRoute(
                                childWidget: UserDetailsVerificationScreen(
                                  document: _businessVerificationList[index],
                                  title: 'Business Verification',
                                  documentType: 'business',
                                ),
                              ),
                            );
                          }
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
                    _showModalBottomSheet('business_verification');
                  },
                  icon: Icon(Icons.security_outlined),
                  fontSize: 12.0,
                ),
                SizedBox(height: 10.0),
                FontHeading(text: 'Business Type'),
                SizedBox(height: 10.0),
                ListTileContainer(
                  title: _businessType,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w400,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _showModalBottomSheet('business_type');
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
                    prefixIcon: Icon(
                      Icons.date_range_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
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
                        !(int.parse(value) >= 1800 &&
                            int.parse(value) <= DateTime.now().year)) {
                      return 'Establishment year should be between 1800 and ${DateTime.now().year}';
                    }
                    return null;
                  },
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
