import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/order_items.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({Key key}) : super(key: key);

  static const routeName = '/payments-screen';

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget _contentList = OrderItems(
    type: 'PAID',
    typeExists: true,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _changeTabContent(int index) {
    switch (index) {
      case 0:
        setState(() {
          _contentList = OrderItems(
            type: 'PAID',
            typeExists: true,
          );
        });
        break;
      case 1:
        setState(() {
          _contentList = OrderItems(
            type: 'DUE',
            typeExists: true,
          );
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
              title: 'Payments',
              containsBackButton: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 3.0,
                    controller: _tabController,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).accentColor,
                    onTap: (value) => _changeTabContent(value),
                    tabs: [
                      Tab(text: 'Pending'),
                      Tab(text: 'Completed'),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                _contentList,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
