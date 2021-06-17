import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/screens/login_screen.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    Key key,
    @required this.email,
  }) : super(key: key);

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmNewPasswordFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();

    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmNewPasswordFocusNode.dispose();
  }

  Future<void> _onFormSubmitted() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    bool isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    try {
      await Provider.of<Auth>(context, listen: false).resetPassword(
        _newPasswordController.text,
        widget.email,
      );

      AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Succes',
          desc: 'Password updated successfully!',
          showCloseIcon: true,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          btnCancelOnPress: null,
          btnOkOnPress: () {},
          btnOkColor: Theme.of(context).primaryColor,
          onDissmissCallback: () {
            Navigator.of(context).pushReplacement(
              FadePageRoute(
                childWidget: LoginScreen(),
              ),
            );
          })
        ..show();

      setState(() {
        _isLoading = false;
      });
    } on HttpException catch (error) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error!',
        desc: error.message,
        showCloseIcon: true,
        btnOkColor: Theme.of(context).primaryColor,
        btnOkOnPress: () {},
      )..show();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error',
        desc: 'Something went wrong!',
        showCloseIcon: true,
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            flexibleSpace: CustomAppBar(
              title: 'Reset Password',
              containsBackButton: true,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            margin: const EdgeInsets.only(top: 40.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FontHeading(text: 'New Password'),
                      SizedBox(height: 10.0),
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _newPasswordController,
                        focusNode: _newPasswordFocusNode,
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
                              .requestFocus(_confirmNewPasswordFocusNode);
                        },
                        validator: (value) {
                          if (value.length < 6) {
                            return 'Password should be at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      FontHeading(text: 'Confirm New Password'),
                      SizedBox(height: 10.0),
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        focusNode: _confirmNewPasswordFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        controller: _confirmNewPasswordController,
                        textInputAction: TextInputAction.done,
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
                        validator: (value) {
                          if (value.length < 6 ||
                              _newPasswordController.text != value) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
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
                                child: !_isLoading
                                    ? Text(
                                        'Update',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
