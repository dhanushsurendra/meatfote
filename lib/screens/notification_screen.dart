import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/widgets/activities_notification.dart';
import 'package:meatforte/widgets/bottom_navigation.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/orders_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BottomNavigation(),
        ),
      ),
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(108.0),
              child: AppBar(
                elevation: 0.0,
                automaticallyImplyLeading: false,
                flexibleSpace: Column(
                  children: [
                    CustomAppBar(
                      title: 'Notifications',
                      containsBackButton: true,
                      isNotificationScreen: true,
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
                          Text('Orders'),
                          Text('Activity'),
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
                  child: OrdersNotification(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                  child: ActivitiesNotification(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}