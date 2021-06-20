import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/widgets/bottom_navigation.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool containsBackButton;
  final bool containsTrailingButton;
  final Icon trailingButtonIcon;
  final Function trailingButtonOnTap;
  final bool isNotificationScreen;

  CustomAppBar({
    Key key,
    @required this.title,
    this.containsBackButton = false,
    this.containsTrailingButton = false,
    this.isNotificationScreen = false,
    this.trailingButtonIcon = const Icon(
      Icons.delete,
      color: Colors.transparent,
      size: 20.0,
    ),
    this.trailingButtonOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
            color: Colors.black26,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.chevronLeft,
                size: 20,
                color: containsBackButton ? Colors.white : Colors.transparent,
              ),
              onPressed: () => containsBackButton && isNotificationScreen
                  ? Navigator.of(context).pushReplacement(
                      FadePageRoute(
                        childWidget: BottomNavigation(),
                      ),
                    )
                  : containsBackButton
                      ? Navigator.of(context).pop()
                      : null,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 20.0,
              ),
            ),
            IconButton(
              icon: trailingButtonIcon,
              onPressed: containsTrailingButton ? trailingButtonOnTap : null,
            )
          ],
        ),
      ),
    );
  }
}
