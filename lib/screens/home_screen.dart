import 'package:flutter/material.dart';
import 'package:meatforte/animations/fade_page_route.dart';
import 'package:meatforte/screens/notification_screen.dart';
import 'package:meatforte/screens/search_input_screen.dart';
import 'package:meatforte/widgets/products_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  static const routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(106),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              flexibleSpace: Column(
                children: [
                  HomeAppBar(),
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
                        Text('Chicken'),
                        Text('Mutton'),
                        Text('Sea Food'),
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
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: ProductsList(
                  type: 'chicken',
                  isFavorite: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: ProductsList(
                  type: 'chicken',
                  isFavorite: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: ProductsList(
                  type: 'chicken',
                  isFavorite: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.30,
              child: Image.asset(
                'assets/images/logo-white.png',
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    FadePageRoute(
                      childWidget: SearchInputScreen(),
                    ),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 25.0,
                  ),
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    FadePageRoute(
                      childWidget: NotificationScreen(),
                    ),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 25.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
