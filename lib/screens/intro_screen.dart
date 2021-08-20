import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/screens/detect_location_screen.dart';
import 'package:meatforte/screens/login_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key key}) : super(key: key);

  static const routeName = '/intro-screen';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      FadePageRoute(
        childWidget: LoginScreen(),
      ),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: IntroductionScreen(
          key: introKey,
          pages: [
            PageViewModel(
              title: "Register",
              body: "Register by finishing the required KYC.",
              image: _buildImage('img1.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Order",
              body:
                  "Place an order in the app by selecting the required items.",
              image: _buildImage('img2.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Delivery",
              body:
                  "Get the required items at your location delivered in the mentioned date.",
              image: _buildImage('img3.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Payment",
              body:
                  "Pay online post order placement or by cash at delivery. Credit will be applicable only for order of 100 kilograms & above.",
              image: _buildImage('img4.png'),
              decoration: pageDecoration,
            ),
          ],
          showSkipButton: true,
          onDone: () => _onIntroEnd(context),
          skipFlex: 0,
          nextFlex: 0,
          skip: TextButton(
            onPressed: () => Navigator.of(context).push(
              FadePageRoute(
                childWidget: LoginScreen(),
              ),
            ),
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).primaryColor.withOpacity(0.15),
              ),
            ),
            child: Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          next: Icon(
            Icons.arrow_forward,
            color: Theme.of(context).primaryColor,
          ),
          done: TextButton(
            onPressed: () => Navigator.of(context).push(
              FadePageRoute(
                childWidget: LoginScreen(),
              ),
            ),
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).primaryColor.withOpacity(0.15),
              ),
            ),
            child: Text(
              'Done',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          curve: Curves.easeIn,
          controlsMargin: const EdgeInsets.all(16),
          controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeColor: Color(0xFFFF0037),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
