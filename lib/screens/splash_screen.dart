import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/screens/detect_location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  static const routeName = '/splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  Future<bool> isFirstTime() async {
    SharedPreferences isFirstTime = await SharedPreferences.getInstance();
    if (isFirstTime.containsKey('location')) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      Duration(seconds: 4),
      () {
        isFirstTime().then(
          (value) {
            print(value);
            if (value) {
              Navigator.of(context).pushReplacementNamed('/');
            } else {
              Navigator.of(context).pushReplacement(
                FadePageRoute(
                  childWidget: DetectLocationScreen(),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
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
