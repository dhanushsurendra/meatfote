import 'package:flutter/material.dart';
import 'package:meatforte/widgets/business_details.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/personal_details.dart';
import 'package:meatforte/widgets/settings_details.dart';

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
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(108.0),
            child: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              flexibleSpace: Column(
                children: [
                  CustomAppBar(
                    title: 'Profile',
                    containsBackButton: true,
                    containsTrailingButton: true,
                  ),
                  Material(
                    color: Colors.white,
                    child: TabBar(
                      physics: BouncingScrollPhysics(),
                      indicatorWeight: 3.0,
                      labelPadding:
                          const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      indicatorColor: Theme.of(context).primaryColor,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Theme.of(context).accentColor,
                      tabs: [
                        Text('Personal'),
                        Text('Business'),
                        Text('Settings'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: PersonalDetails(inApp: true),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: BusinessDetails(),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: SettingsDetails(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SafeArea(
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(60.0),
//           child: AppBar(
//             elevation: 0.0,
//             automaticallyImplyLeading: false,
//             flexibleSpace: CustomAppBar(
//               title: 'Profile',
//               containsBackButton: true,
//               containsTrailingButton: true,
//               trailingButtonIcon: Icon(
//                 Icons.delete_outline_rounded,
//                 color: Colors.white,
//               ),
//               trailingButtonOnTap: () => ShowDialog.showDialog(
//                 context,
//                 DialogType.WARNING,
//                 'Delete Account',
//                 'Are you sure you want to delete your accout? All your data will be deleted permanently.',
//                 () => Navigator.of(context).push(
//                   FadePageRoute(
//                     childWidget: LoginScreen(),
//                   ),
//                 ),
//                 true,
//                 () {},
//               ),
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(height: 10.0),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: TabLayout(
//                   type: 'Profile',
//                   categories: ['Personal', 'Business', 'Settings'],
//                   initialValue: PersonalDetails(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
