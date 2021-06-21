import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/product.dart';
import 'package:meatforte/providers/products.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/empty_image.dart';
import 'package:meatforte/widgets/error_handler.dart';
import 'package:meatforte/widgets/list_item.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> _getFavorites(String userId) async {
    await Provider.of<Products>(context, listen: false).getFavorites(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAppBar(
              title: 'Favorites',
              containsBackButton: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FutureBuilder(
                  future: Provider.of<Products>(context, listen: false)
                      .getFavorites(userId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return ListItem(
                            product: null,
                            isCart: false,
                            isFavorite: false,
                            isLoading: true,
                            isInStock: true,
                            textFieldEnabled: false,
                          );
                        },
                      );
                    }

                    if (snapshot.hasError) {
                      return RefreshIndicator(
                        color: Theme.of(context).primaryColor,
                        onRefresh: () => _getFavorites(userId),
                        child: ErrorHandler(
                          message: 'Something went wrong. Please try again.',
                          heightPercent: 0.823,
                        ),
                      );
                    }

                    return Provider.of<Products>(context).favorites.length == 0
                        ? EmptyImage(
                            message: 'No favorites yet. Start adding some!',
                            imageUrl: 'assets/images/empty.png',
                            heightPercent: 0.7,
                          )
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount:
                                Provider.of<Products>(context).favorites.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Product product =
                                  Provider.of<Products>(context)
                                      .favorites[index];

                              return ChangeNotifierProvider.value(
                                value: product,
                                child: ListItem(
                                  product: product,
                                  isCart: false,
                                  containsAddToCartButton: true,
                                  isFavorite: false,
                                  deleteType: 'FAVORITES',
                                  isInStock: product.isInStock,
                                  textFieldEnabled: product.isInStock,
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
