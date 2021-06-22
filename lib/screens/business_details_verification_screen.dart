import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/screens/pending_verification_screen.dart';
import 'package:meatforte/widgets/business_details.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/personal_details.dart';

class BusinessDetailsVerificationScreen extends StatelessWidget {
  const BusinessDetailsVerificationScreen({Key key}) : super(key: key);

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
              title: 'Business Verification',
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
          child: BusinessDetails(
            buttonText: 'Continue',
          ),
        ),
      ),
    );
  }
}
