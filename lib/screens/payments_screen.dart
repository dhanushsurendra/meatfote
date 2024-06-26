import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/screens/search_input_screen.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/order_items.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({Key key}) : super(key: key);

  static const routeName = '/payments-screen';

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
                    title: 'Payments',
                    containsBackButton: true,
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
                    child: TabBar(
                      physics: BouncingScrollPhysics(),
                      indicatorWeight: 3.0,
                      labelPadding:
                          const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      indicatorColor: Theme.of(context).primaryColor,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Theme.of(context).accentColor,
                      tabs: [
                        Text('Pending'),
                        Text('Completed'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: OrderItems(
                  typeExists: true,
                  type: 'DUE',
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: OrderItems(
                  typeExists: true,
                  type: 'PAID',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
