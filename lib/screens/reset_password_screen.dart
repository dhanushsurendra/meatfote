import 'package:flutter/material.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(106),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          flexibleSpace: CustomAppBar(
            title: 'Reset Password',
          ),
        ),
      ),
    );
  }
}
