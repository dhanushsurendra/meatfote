import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/helpers/show_dialog.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/screens/all_orders_screen.dart';
import 'package:meatforte/screens/login_screen.dart';
import 'package:meatforte/screens/payments_screen.dart';
import 'package:meatforte/screens/webview_screen.dart';
import 'package:meatforte/screens/user_account_screen.dart';
import 'package:meatforte/widgets/list_tile_container.dart';
import 'package:meatforte/widgets/profile_image.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  Widget _buildListTile(
    String title,
    Function onTap,
    Icon icon,
    BuildContext context,
  ) {
    return ListTileContainer(
      icon: icon,
      onTap: onTap,
      title: title,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.0,
    );
  }

  Widget _buildAsyncListTile(
    String title,
    Icon icon,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
            color: Colors.black12,
          )
        ],
      ),
      child: Material(
        child: InkWell(
          onTap: () async => await Share.share('https://www.xnxx.com'),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 45.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFEBEBF1),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Center(child: icon),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 14.0,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 20.0,
                    color: Colors.grey[400].withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map> _listItems = [
      {'key': 'Account', 'value': Icon(Icons.person_outline_outlined)},
      {'key': 'Orders', 'value': Icon(Icons.shopping_bag_outlined)},
      {'key': 'Payments', 'value': Icon(Icons.credit_card_outlined)},
      {'key': 'Policies', 'value': Icon(Icons.verified_outlined)},
      {'key': 'Invite Friends', 'value': Icon(Icons.group_add_outlined)},
      {'key': 'Support', 'value': Icon(Icons.support_agent_outlined)},
      {'key': 'Terms of Use', 'value': Icon(Icons.description_outlined)},
      {'key': 'About Us', 'value': Icon(Icons.info_outline)},
      {'key': 'Logout', 'value': Icon(Icons.logout)},
    ];

    List<Function> _listItemNavigation = [
      () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: UserAccountScreen(),
            ),
          ),
      () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: AllOrdersScreen(isSearchResult: false,),
            ),
          ),
      () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: PaymentsScreen(),
            ),
          ),
      () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: WebViewScreen(
                title: 'Policies',
                websiteUrl: 'https://flutter.dev',
              ),
            ),
          ),
      () => {},
      () => ShowDialog.showDialog(context, DialogType.INFO, 'Contact Support',
          '+91 9880533192', () {}, false, () {}),
      () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: WebViewScreen(
                title: 'Terms of Use',
                websiteUrl: 'https://flutter.dev',
              ),
            ),
          ),
      () => Navigator.of(context).push(
            FadePageRoute(
              childWidget: WebViewScreen(
                title: 'About Us',
                websiteUrl: 'https://flutter.dev',
              ),
            ),
          ),
      () => AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Confirm logout',
            desc: 'Are you sure you want to logout?',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
            onDissmissCallback: () {
              Navigator.of(context).pushReplacement(
                FadePageRoute(
                  childWidget: LoginScreen(),
                ),
              );
            },
            btnOkColor: Color(0xFF00CA71),
            btnCancelColor: Theme.of(context).primaryColor,
          )..show()
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40.0,
                    ),
                    ProfileImage(),
                    SizedBox(height: 5.0),
                    Text(
                      'manishvishwa777',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Text(
                      'manishvishwa777@gmail.com',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Column(
                children: _listItems.asMap().entries.map(
                  (entry) {
                    int index = entry.key;
                    String key = entry.value['key'];
                    Icon icon = entry.value['value'];

                    if (index == 4) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: _buildAsyncListTile(
                          key,
                          icon,
                          context,
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: _buildListTile(
                        key,
                        _listItemNavigation[index],
                        icon,
                        context,
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
