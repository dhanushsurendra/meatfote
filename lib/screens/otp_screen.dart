import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/screens/reset_password_screen.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  final String email;

  const OTPScreen({
    Key key,
    @required this.email,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController controller = TextEditingController(text: '');
  String thisText = '';
  int pinLength = 4;
  bool hasError = false;
  String errorMessage;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _isLoading = false;

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
              title: 'Verify OTP',
              containsBackButton: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.0),
                  Text(
                    'Enter the 4 digit OTP sent to your email.',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Enter the OTP',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PinCodeTextField(
                          autofocus: true,
                          controller: controller,
                          defaultBorderColor: Colors.grey,
                          maxLength: pinLength,
                          hasError: hasError,
                          onTextChanged: (text) {
                            setState(() {
                              hasError = false;
                            });
                          },
                          pinBoxWidth: MediaQuery.of(context).size.width / 5,
                          pinBoxHeight: 60,
                          hasUnderline: false,
                          wrapAlignment: WrapAlignment.start,
                          pinBoxDecoration: ProvidedPinBoxDecoration
                              .underlinedPinBoxDecoration,
                          pinTextStyle: TextStyle(fontSize: 22.0),
                          pinTextAnimatedSwitcherTransition:
                              ProvidedPinBoxTextAnimation.scalingTransition,
                          pinTextAnimatedSwitcherDuration:
                              Duration(milliseconds: 300),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    child: Text(
                      'Wrong PIN!',
                    ),
                    visible: hasError,
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Material(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5.0),
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await Provider.of<Auth>(context, listen: false)
                                .verifyOTP(
                              widget.email,
                              controller.text,
                            );

                            Navigator.of(context).push(
                              FadePageRoute(
                                childWidget: ResetPasswordScreen(
                                  email: widget.email,
                                  isInApp: false,
                                ),
                              ),
                            );

                            setState(() {
                              _isLoading = false;
                            });
                            
                          } on HttpException catch (error) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Error',
                              desc: error.message,
                              showCloseIcon: true,
                              btnOkColor: Theme.of(context).primaryColor,
                            )..show();
                            setState(() {
                              _isLoading = false;
                            });
                          } catch (error) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Error!',
                              desc: 'Something went wrong.',
                              showCloseIcon: true,
                              btnOkColor: Theme.of(context).primaryColor,
                            )..show();
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive OTP? ',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Provider.of<Auth>(context, listen: false)
                              .sendOTP(widget.email);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('A code has been sent to your email'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          'Resend',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
