import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/notification.dart';
import 'package:meatforte/screens/order_details_screen.dart';
import 'package:meatforte/widgets/empty_image.dart';
import 'package:provider/provider.dart';

class ActivitiesNotification extends StatelessWidget {
  const ActivitiesNotification({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          EmptyImage(
            message: 'No activity yet :)',
            imageUrl: 'assets/images/empty.png',
            heightPercent: MediaQuery.of(context).size.width <= 320 ? .60 : .75,
          )
        ],
      ),
    );
  }
}