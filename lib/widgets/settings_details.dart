import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/font_heading.dart';
import 'package:meatforte/helpers/show_dialog.dart';
import 'package:meatforte/screens/add_team_member_screen.dart';
import 'package:meatforte/screens/login_screen.dart';
import 'package:meatforte/screens/manage_address_screen.dart';
import 'package:meatforte/screens/reset_password_screen.dart';
import 'package:meatforte/widgets/list_tile_container.dart';

class SettingsDetails extends StatelessWidget {
  const SettingsDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FontHeading(text: 'Manage Address'),
        SizedBox(height: 10.0),
        ListTileContainer(
          title: 'Edit or delete address',
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
          onTap: () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: ManageAddressScreen(
                type: 'MANAGE',
                title: 'Manage Address',
              ),
            ),
          ),
          icon: Icon(Icons.map_outlined),
          fontSize: 12.0,
        ),
        SizedBox(height: 10.0),
        FontHeading(text: 'Team Member'),
        SizedBox(height: 10.0),
        ListTileContainer(
          title: 'Add Team Member',
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
          onTap: () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: AddTeamMemberScreen(),
            ),
          ),
          icon: Icon(Icons.group_add_outlined),
          fontSize: 12.0,
        ),
        SizedBox(height: 10.0),
        FontHeading(text: 'Change Password'),
        SizedBox(height: 10.0),
        ListTileContainer(
          title: 'Set New Password',
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
          onTap: () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: ResetPasswordScreen(isInApp: true),
            ),
          ),
          icon: Icon(Icons.lock_outlined),
          fontSize: 12.0,
        ),
        SizedBox(height: 10.0),
        FontHeading(text: 'Delete Account'),
        SizedBox(height: 10.0),
        ListTileContainer(
          title: 'Delete My Account',
          letterSpacing: 0.0,
          fontWeight: FontWeight.w400,
          onTap: () => ShowDialog.showDialog(
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
          icon: Icon(Icons.delete_outlined),
          fontSize: 12.0,
        ),
      ],
    );
  }
}
