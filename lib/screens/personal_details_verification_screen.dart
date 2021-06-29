import 'package:flutter/material.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/personal_details.dart';

class PersonalDetailsVerificationScreen extends StatelessWidget {
  const PersonalDetailsVerificationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            flexibleSpace: CustomAppBar(
              title: 'Personal Verification',
              containsBackButton: true,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 32.0,
            left: 16.0,
            right: 16.0,
          ),
          child: PersonalDetails(
            buttonText: 'Continue',
            inApp: false,
          ),
        ),
      ),
    );
  }
}
