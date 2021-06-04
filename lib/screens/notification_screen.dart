import 'package:flutter/material.dart';
import 'package:meatforte/widgets/activities_notification.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/orders_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget _contentList = ActivitiesNotification();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _changeTabContent(int index) {
    switch (index) {
      case 0:
        setState(() {
          _contentList = ActivitiesNotification();
        });
        break;
      case 1:
        setState(() {
          _contentList = OrdersNotification();
        });
        break;
      default:
        setState(() {});
    }
  }

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
              title: 'Notifications',
              containsBackButton: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3.0,
                  physics: BouncingScrollPhysics(),
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).accentColor,
                  onTap: (value) => _changeTabContent(value),
                  tabs: [
                    Tab(text: 'Activity'),
                    Tab(text: 'Orders'),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              _contentList,
            ],
          ),
        ),
      ),
    );
  }
}
