import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/show_dialog.dart';
import 'package:meatforte/screens/login_screen.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/personal_details.dart';
import 'package:meatforte/widgets/tab_layout.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({Key key}) : super(key: key);

  static const routeName = '/user-account';

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
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
              title: 'Profile',
              containsBackButton: true,
              containsTrailingButton: true,
              trailingButtonIcon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
              ),
              trailingButtonOnTap: () => ShowDialog.showDialog(
                context,
                DialogType.WARNING,
                'Delete Account',
                'Are you sure you want to delete your accout? All your data will be deleted permanently.',
                () => Navigator.of(context).push(
                  FadePageRoute(
                    childWidget: LoginScreen(),
                  ),
                ),
                true,
                () {},
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TabLayout(
                  type: 'Profile',
                  categories: ['Personal', 'Business', 'Settings'],
                  initialValue: PersonalDetails(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
