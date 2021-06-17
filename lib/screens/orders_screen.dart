import 'package:flutter/material.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/order_items.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(108.0),
            child: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              flexibleSpace: Column(
                children: [
                  CustomAppBar(
                    title: 'Orders',
                    containsBackButton: false,
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
                        Text('Shipped'),
                        Text('Delivered'),
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
            ],
          ),
        ),
      ),
    );
  }
}

// FutureBuilder(
//           future: Provider.of<Orders>(context, listen: false).getOrders(userId),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             return Container(
//               child: SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: SearchFieldContainer(),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: TabLayout(
//                         type: 'ORDERS',
//                         categories: ['Pending', 'Shipped', 'Delivered'],
//                         initialValue: OrderItems(
//                           status: 'PENDING',
//                           typeExists: false,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
