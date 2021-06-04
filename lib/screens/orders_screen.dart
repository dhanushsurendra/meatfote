import 'package:flutter/material.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/order_items.dart';
import 'package:meatforte/widgets/search_field_container.dart';
import 'package:meatforte/widgets/tab_layout.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(52.0),
          child: AppBar(
            elevation: 0.0,
            flexibleSpace: CustomAppBar(
              title: 'Orders',
              containsBackButton: false,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchFieldContainer(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TabLayout(
                  type: 'ORDERS',
                  categories: ['Pending', 'Shipped', 'Delivered'],
                  initialValue: OrderItems(
                    status: 'PENDING',
                    typeExists: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
