import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/screens/search_input_screen.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/order_items.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120.0),
            child: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              flexibleSpace: Column(
                children: [
                  CustomAppBar(
                    title: 'Orders',
                    containsBackButton: false,
                    containsTrailingButton: true,
                    trailingButtonIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    trailingButtonOnTap: () {
                      Navigator.of(context).push(
                        FadePageRoute(
                          childWidget: SearchInputScreen(type: 'SEARCH_ORDERS'),
                        ),
                      );
                    },
                  ),
                  Material(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TabBar(
                        controller: _tabController,
                        physics: BouncingScrollPhysics(),
                        indicatorWeight: 3.0,
                        isScrollable: MediaQuery.of(context).size.width >= 575 ? false : true,
                        indicatorColor: Theme.of(context).primaryColor,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Theme.of(context).accentColor,
                        tabs: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text('Pending'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text('Rejected'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text('Shipped'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text('Delivered'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, top: 8.0),
                            child: Text('Returned'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: OrderItems(
                  typeExists: false,
                  type: 'PENDING',
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: OrderItems(
                  typeExists: false,
                  type: 'REJECTED',
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: OrderItems(
                  typeExists: false,
                  type: 'SHIPPED',
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: OrderItems(
                  typeExists: false,
                  type: 'DELIVERED',
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: OrderItems(
                  typeExists: false,
                  type: 'RETURNED',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
