import 'package:flutter/material.dart';
import 'package:meatforte/widgets/order_items.dart';
import 'package:meatforte/widgets/personal_details.dart';
import 'package:meatforte/widgets/products_list.dart';
import 'package:meatforte/widgets/settings_details.dart';

import 'business_details.dart';

class TabLayout extends StatefulWidget {
  final String type;
  final List<String> categories;
  final Widget initialValue;

  TabLayout({
    Key key,
    @required this.type,
    @required this.categories,
    @required this.initialValue,
  }) : super(key: key);

  @override
  _TabLayoutState createState() => _TabLayoutState();
}

class _TabLayoutState extends State<TabLayout>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Widget _contentList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _contentList = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    void _changeTabContent(int index) {
      switch (index) {
        case 0:
          setState(() {
            _contentList = widget.type == 'FOOD'
                ? ProductsList(
                    type: 'chicken',
                    isFavorite: true,
                  )
                : widget.type == 'Profile'
                    ? PersonalDetails()
                    : OrderItems(
                        status: 'PENDING',
                        typeExists: false,
                      );
          });
          break;
        case 1:
          setState(() {
            _contentList = widget.type == 'FOOD'
                ? ProductsList(
                    type: 'mutton',
                    isFavorite: true,
                  )
                : widget.type == 'Profile'
                    ? BusinessDetails()
                    : OrderItems(
                        status: 'SHIPPED',
                        typeExists: false,
                      );
          });
          break;
        case 2:
          setState(
            () {
              _contentList = widget.type == 'FOOD'
                  ? ProductsList(
                      type: 'sea food',
                      isFavorite: true,
                    )
                  : widget.type == 'Profile'
                      ? SettingsDetails()
                      : OrderItems(
                          status: 'DELIVERED',
                          typeExists: false,
                        );
            },
          );
          break;
        default:
          setState(() {});
      }
    }

    return Column(
      children: [
        TabBar(
          physics: BouncingScrollPhysics(),
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          indicatorColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).accentColor,
          indicatorWeight: 3.0,
          onTap: (value) => _changeTabContent(value),
          tabs: widget.categories
              .asMap()
              .map(
                (index, value) => MapEntry(
                  index,
                  Tab(text: widget.categories[index]),
                ),
              )
              .values
              .toList(),
        ),
        SizedBox(height: 20.0),
        _contentList,
      ],
    );
  }
}
