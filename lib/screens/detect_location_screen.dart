import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meatforte/screens/intro_screen.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

class DetectLocationScreen extends StatefulWidget {
  const DetectLocationScreen({Key key}) : super(key: key);

  @override
  _DetectLocationScreenState createState() => _DetectLocationScreenState();
}

class _DetectLocationScreenState extends State<DetectLocationScreen> {
  bool _isLoading = false;

  Future<void> _detectLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error!',
          desc: 'Location services are not enabled. Enable it to continue.',
          btnOkOnPress: () => {},
          btnOkColor: Theme.of(context).primaryColor,
        )..show();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error!',
          desc: 'Permission denied. Enable it to detect location.',
          btnOkOnPress: () => {},
          btnOkColor: Theme.of(context).primaryColor,
        )..show();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error!',
        desc: 'Permission denied for this app. Enable it in settings.',
        btnOkOnPress: () => {},
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    //final coordinates = new Coordinates(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks[0].locality != "Bengaluru") {
      setState(() {
        _isLoading = false;
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error!',
        desc:
            'Sorry, we currrently don\'t operate at your location. Coming soon!',
        btnOkOnPress: () => {},
        btnOkColor: Theme.of(context).primaryColor,
      )..show();
    } else {
      setState(() {
        _isLoading = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('location', true);

      Navigator.of(context).pushReplacement(
        FadePageRoute(
          childWidget: IntroScreen(),
        ),
      );
    }
  }

  // 10 - .3 20 - .6 50 -  34 65 78

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Image.asset('assets/images/logo_with_tagline.png'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Image.asset('assets/images/location.png'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Divider(),
              Text('Please share your delivery location'),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Material(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      onTap: () async => await _detectLocation(),
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
                                  'Use My Current Location',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    color: Colors.transparent,
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
