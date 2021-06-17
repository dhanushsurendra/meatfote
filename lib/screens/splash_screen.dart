import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  static const routeName = '/splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacementNamed('/');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
        ),
        toolbarHeight: 0.0,
      ),
      body: SafeArea(
        child: Container(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).size.height - 80.0,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Image(
                image: AssetImage(
                  'assets/images/logo-white.png',
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).primaryColor,
        height: 80.0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 36.0),
            child: SpinKitFadingCircle(
              color: Colors.white,
              size: 50.0,
            ),
          ),
        ),
      ),
    );
  }
}
