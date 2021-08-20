import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/screens/otp_screen.dart';
import 'package:meatforte/widgets/button.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class SendOTPScreen extends StatefulWidget {
  const SendOTPScreen({Key key}) : super(key: key);

  @override
  _SendOTPScreenState createState() => _SendOTPScreenState();
}

class _SendOTPScreenState extends State<SendOTPScreen> {
  final _emailController = TextEditingController();

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
              title: 'Email Verify',
              containsBackButton: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Your Email Addess',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      cursorColor: Theme.of(context).primaryColor,
                      controller: _emailController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
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
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await Provider.of<Auth>(context, listen: false)
                                  .sendOTP(_emailController.text);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('A code has been sent to your email.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              Navigator.of(context).push(
                                FadePageRoute(
                                  childWidget:
                                      OTPScreen(email: _emailController.text),
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
                                title: 'Error',
                                desc: 'Something went wrong',
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
                                      'Send',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
