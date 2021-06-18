import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meatforte/providers/notification.dart';
import 'package:meatforte/providers/addresses.dart';
import 'package:meatforte/providers/cart.dart';
import 'package:meatforte/providers/orders.dart';
import 'package:meatforte/providers/products.dart';
import 'package:meatforte/providers/search.dart';
import 'package:meatforte/providers/team_members.dart';
import 'package:meatforte/screens/all_orders_screen.dart';
import 'package:meatforte/screens/home_screen.dart';
import 'package:meatforte/screens/intro_screen.dart';
import 'package:meatforte/screens/login_screen.dart';
import 'package:meatforte/screens/payments_screen.dart';
import 'package:meatforte/screens/splash_screen.dart';
import 'package:meatforte/screens/user_account_screen.dart';
import 'package:meatforte/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light // status bar color
        ),
  );

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider<Products>(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider<Search>(
          create: (ctx) => Search(),
        ),
        ChangeNotifierProvider<Orders>(
          create: (ctx) => Orders(),
        ),
        ChangeNotifierProvider<Addresses>(
          create: (ctx) => Addresses(),
        ),
        ChangeNotifierProvider<Notifications>(
          create: (ctx) => Notifications(),
        ),
        ChangeNotifierProvider<TeamMembers>(
          create: (ctx) => TeamMembers(),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, widget) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Meatforte',
          theme: ThemeData(
            primaryColor: Color(0xFFFF0037),
            accentColor: Color(0xFF202126),
            fontFamily: 'Poppins',
            canvasColor: Colors.white,
          ),
          initialRoute: '/splash-screen',
          home: auth.isAuth
              ? BottomNavigation()
              : FutureBuilder(
                  future:
                      Provider.of<Auth>(context, listen: false).tryAutoSignIn(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          routes: {
            SplashScreen.routeName: (ctx) => SplashScreen(),
            BottomNavigation.routeName: (ctx) => BottomNavigation(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            IntroScreen.routeName: (ctx) => IntroScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            AllOrdersScreen.routeName: (ctx) => AllOrdersScreen(),
            PaymentsScreen.routeName: (ctx) => PaymentsScreen(),
            UserAccountScreen.routeName: (ctx) => UserAccountScreen(),
          },
        ),
      ),
    );
  }
}

// Colors
// primary color = Color(0xFFFF0037)
// secondary color = Color(0xFF202126)
// Grey = Color(0xFFCAD1DB)
