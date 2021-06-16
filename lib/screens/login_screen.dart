import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/screens/signup_screen.dart';
import 'package:meatforte/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailPhoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _emailPhoneNumberFocusScope = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailPhoneNumberController.dispose();
    _passwordController.dispose();

    _emailPhoneNumberFocusScope.dispose();
    _passwordFocusNode.dispose();
  }

  bool _obscurePasswordText = true;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    void _showErrorDialog(String error) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error!',
        desc: error,
        showCloseIcon: true,
        btnOkOnPress: () {},
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
    }

    Future<void> _onFormSubmitted() async {
      final isValid = _formKey.currentState.validate();
      if (!isValid) {
        return;
      }

      FocusScope.of(context).unfocus();

      setState(() {
        _isLoading = true;
      });

      var _identifier = 'PHONE_NUMBER';

      if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_emailPhoneNumberController.text)) {
        _identifier = 'EMAIL';
      } else if (int.tryParse(_emailPhoneNumberController.text) == null) {
        _identifier = 'PHONE_NUMBER';
      }

      try {
        await Provider.of<Auth>(context, listen: false).login(
          _emailPhoneNumberController.text.trim(),
          _passwordController.text.trim(),
          _identifier,
        );
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushReplacement(
          FadePageRoute(
            childWidget: BottomNavigation(),
          ),
        );
      } on SocketException catch (_) {
        setState(() {
          _isLoading = false;
        });
        const errorMessage =
            'Could not authenticate you. Please try again later';
        _showErrorDialog(errorMessage);
      } on HttpException catch (error) {
        setState(() {
          _isLoading = false;
        });
        var errorMessage = 'Authentication Failed!';
        errorMessage = error.toString();
        _showErrorDialog(errorMessage);
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        const errorMessage =
            'Could not authenticate you. Please try again later';
        _showErrorDialog(errorMessage);
      }

      // bool isValid = _formKey.currentState.validate();

      // if (!isValid) {
      //   return null;
      // }

      // FocusScope.of(context).unfocus();

      // ProgressDialog progressDialog = new ProgressDialog(
      //   context,
      //   customBody: Container(
      //     width: MediaQuery.of(context).size.width * 0.90,
      //     height: 80.0,
      //     child: Padding(
      //       padding: const EdgeInsets.only(left: 20.0),
      //       child: Row(
      //         children: [
      //           CircularProgressIndicator(
      //             valueColor: AlwaysStoppedAnimation<Color>(
      //               Theme.of(context).primaryColor,
      //             ),
      //           ),
      //           SizedBox(
      //             width: 20.0,
      //           ),
      //           Text(
      //             'Authenticating...',
      //             style: TextStyle(
      //               color: Theme.of(context).accentColor,
      //               fontSize: 18.0,
      //               fontWeight: FontWeight.w600,
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      //   isDismissible: false,
      // );

      // progressDialog.show();

      // var _identifier = 'PHONE_NUMBER';

      // if (RegExp(
      //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //     .hasMatch(_emailPhoneNumberController.text)) {
      //   _identifier = 'EMAIL';
      // } else if (int.tryParse(_emailPhoneNumberController.text) == null) {
      //   _identifier = 'PHONE_NUMBER';
      // }

      // try {
      //   Provider.of<Auth>(context, listen: false).login(
      //     _emailPhoneNumberController.text,
      //     _passwordController.text,
      //     _identifier,
      //   );
      //   progressDialog.hide();
      //   setState(() {});
      // } on HttpException catch (error) {
      //   progressDialog.hide();
      //   var errorMessage = 'Authentication Failed!';
      //   errorMessage = error.toString();
      //   _showErrorDialog(errorMessage);
      // } catch (error) {
      //   progressDialog.hide();
      //   const errorMessage =
      //       'Could not authenticate you. Please try again later';
      //   _showErrorDialog(errorMessage);
      // }
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.0),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FontHeading(text: 'Email or Phone Number'),
                      SizedBox(height: 10.0),
                      TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _emailPhoneNumberController,
                        focusNode: _emailPhoneNumberFocusScope,
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
                              .requestFocus(_passwordFocusNode);
                        },
                        validator: (value) {
                          if (int.tryParse(value) != null ||
                              value.endsWith('.com') && value.contains('@')) {
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Invalid email address';
                            }
                          } else if (int.tryParse(value) == null ||
                              value.length < 10 ||
                              value.length > 10) {
                            return 'Invalid phone number';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      FontHeading(text: 'Password'),
                      SizedBox(height: 10.0),
                      TextFormField(
                        obscureText: _obscurePasswordText,
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.done,
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
                          suffixIcon: IconButton(
                            color: Theme.of(context).primaryColor,
                            icon: _obscurePasswordText
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(
                                () {
                                  _obscurePasswordText = !_obscurePasswordText;
                                },
                              );
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value.length < 6) {
                            return 'Password should be at least 6 characters.';
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
                                        'Login',
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
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          width: double.infinity,
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account? ',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  FadePageRoute(
                    childWidget: SignupScreen(),
                  ),
                ),
                child: Text(
                  'Signup',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
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
