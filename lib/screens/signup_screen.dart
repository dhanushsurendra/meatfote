import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/helpers/show_dialog.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/screens/login_screen.dart';
import 'package:meatforte/screens/personal_details_verification_screen.dart';
import 'package:meatforte/screens/webview_screen.dart';
import 'package:meatforte/widgets/bottom_navigation.dart';
import 'package:meatforte/widgets/button.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  static const routeName = '/signup-screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _checkboxValue = false;

  final _formKey = GlobalKey<FormState>();

  final _emailPhoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FocusNode _emailPhoneNumberFocusScope = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailPhoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _emailPhoneNumberFocusScope.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
  }

  bool _obscurePasswordText = true;
  bool _isLoading = false;
  bool _obscureConfirmPasswordText = true;

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
      bool isValid = _formKey.currentState.validate();

      if (!_checkboxValue &&
          _emailPhoneNumberController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please accept T&C and Privacy Policy',
            ),
          ),
        );
        return;
      }

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
        await Provider.of<Auth>(context, listen: false).signUp(
          _emailPhoneNumberController.text,
          _passwordController.text,
          _identifier,
        );

        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).push(
          FadePageRoute(
            childWidget: PersonalDetailsVerificationScreen(),
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
                      'Sign up',
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
                          if (value.endsWith('.com') || value.contains('@')) {
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
                      SizedBox(height: 10.0),
                      FontHeading(text: 'Confirm Password'),
                      SizedBox(height: 10.0),
                      TextFormField(
                        obscureText: _obscureConfirmPasswordText,
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
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
                            icon: _obscureConfirmPasswordText
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(
                                () {
                                  _obscureConfirmPasswordText =
                                      !_obscureConfirmPasswordText;
                                },
                              );
                            },
                          ),
                        ),
                        validator: (value) {
                          if (_passwordController.text != value) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            value: _checkboxValue,
                            onChanged: (value) {
                              setState(() {
                                _checkboxValue = value;
                              });
                            },
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'I agree to Meatforte\'s ',
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        FadePageRoute(
                                          childWidget: WebViewScreen(
                                            title: 'Terms of Use',
                                            websiteUrl: 'https://flutter.dev',
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'T&C ',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 13.0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'and ',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    FadePageRoute(
                                      childWidget: WebViewScreen(
                                        title: 'Privacy Policy',
                                        websiteUrl: 'https://flutter.dev',
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                                        'Continue',
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
                'Already a member? ',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  FadePageRoute(
                    childWidget: LoginScreen(),
                  ),
                ),
                child: Text(
                  'Login',
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
