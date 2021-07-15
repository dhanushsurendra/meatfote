import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meatforte/screens/cart_screen.dart';
import 'package:meatforte/screens/favorites_screen.dart';

import 'package:meatforte/screens/home_screen.dart';
import 'package:meatforte/screens/orders_screen.dart';
import 'package:meatforte/screens/profile_screen.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key key}) : super(key: key);

  static const routeName = '/bottom-navigation';

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _bottomNavigationItems = [
      HomeScreen(),
      FavoritesScreen(),
      CartScreen(isAllOrders: false,),
      OrdersScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: _bottomNavigationItems[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home_outlined,
              size: 28.0,
            ),
            activeIcon: Icon(
              Icons.home,
              size: 28.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Favorites',
            icon: Icon(
              Icons.favorite_border,
              size: 25.0,
            ),
            activeIcon: Icon(
              Icons.favorite,
              size: 25.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: 25.0,
            ),
            activeIcon: Icon(
              Icons.shopping_cart,
              size: 25.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Orders',
            icon: Icon(
              Icons.shopping_bag_outlined,
              size: 25.0,
            ),
            activeIcon: Icon(
              Icons.shopping_bag,
              size: 25.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: FaIcon(
              FontAwesomeIcons.user,
              size: 22.0,
            ),
            activeIcon: FaIcon(
              FontAwesomeIcons.userAlt,
              size: 22.0,
            ),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
