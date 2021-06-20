import 'package:flutter/material.dart';
import 'package:meatforte/widgets/activities_notification.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/orders_notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }
}

// SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
//                   child: TabBar(
//                     indicatorColor: Theme.of(context).primaryColor,
//                     indicatorWeight: 3.0,
//                     physics: BouncingScrollPhysics(),
//                     controller: _tabController,
//                     labelColor: Theme.of(context).primaryColor,
//                     unselectedLabelColor: Theme.of(context).accentColor,
//                     onTap: (value) => _changeTabContent(value),
//                     tabs: [
//                       Tab(text: 'Activity'),
//                       Tab(text: 'Orders'),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 _contentList,
//               ],
//             ),
//           ),
