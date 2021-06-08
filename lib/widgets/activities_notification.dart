import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/providers/notification.dart';
import 'package:meatforte/screens/order_details_screen.dart';
import 'package:provider/provider.dart';

class ActivitiesNotification extends StatelessWidget {
  const ActivitiesNotification({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: Provider.of<Notifications>(context, listen: false)
            .activities
            .length,
        itemBuilder: (BuildContext context, int index) {
          final NotificationItem activity =
              Provider.of<Notifications>(context, listen: false)
                  .activities[index];
          if (activity.type == 'ACTIVITY') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () => Navigator.of(context).push(
                    FadePageRoute(
                      childWidget: OrderDetailsScreen(
                        isOrderSummary: false,
                        title: 'Order Details',
                        orderId:
                            Provider.of<Notifications>(context, listen: false)
                                .activities[index]
                                .orderId,
                      ),
                    ),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .10,
                    width: double.infinity,
                    color: activity.read
                        ? Colors.transparent
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Payment update on Order: #${activity.orderId}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              activity.subTitle,
                              maxLines: 3,
                              softWrap: true,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
