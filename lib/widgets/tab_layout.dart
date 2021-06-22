import 'package:flutter/material.dart';
import 'package:meatforte/widgets/products_list.dart';

class TabLayout extends StatefulWidget {
  final List<String> categories;
  final Widget initialValue;

  TabLayout({
    Key key,
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
            _contentList = ProductsList(
              type: 'chicken',
              isFavorite: true,
            );
          });
          break;
        case 1:
          setState(() {
            _contentList = ProductsList(
              type: 'mutton',
              isFavorite: true,
            );
          });
          break;
        case 2:
          setState(
            () {
              ProductsList(
                type: 'sea food',
                isFavorite: true,
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
