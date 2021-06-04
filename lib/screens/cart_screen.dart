import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/cart.dart';
import 'package:meatforte/providers/product.dart';
import 'package:meatforte/providers/products.dart';
import 'package:meatforte/widgets/bottom_bar.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/empty_image.dart';
import 'package:meatforte/widgets/error_handler.dart';
import 'package:meatforte/widgets/list_item.dart';
import 'package:meatforte/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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

  Future<void> _getCartItems(String userId) async {
    await Provider.of<Cart>(context, listen: false).getCartItems(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  CustomAppBar(
                    title: 'Cart',
                    containsBackButton: false,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: FutureBuilder(
                        future: Provider.of<Cart>(context, listen: false)
                            .getCartItems(userId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ShimmerLoading();
                          }

                          if (snapshot.hasError) {
                            return RefreshIndicator(
                              onRefresh: () => _getCartItems(userId),
                              child: ErrorHandler(
                                message:
                                    'Something went wrong. Please try again.',
                                heightPercent: 0.823,
                              ),
                            );
                          }

                          return Provider.of<Cart>(context).cartItems.length ==
                                  0
                              ? EmptyImage(
                                  message:
                                      'No items in cart. Start adding some!',
                                  imageUrl: 'assets/images/empty_cart.png',
                                )
                              : ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      Provider.of<Cart>(context, listen: false)
                                          .cartItems
                                          .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Product product =
                                        Provider.of<Cart>(context)
                                            .cartItems[index];

                                    if (index ==
                                        Provider.of<Cart>(context)
                                                .cartItems
                                                .length -
                                            1) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 60.0),
                                        child: ListItem(
                                          product: product,
                                          isCart: true,
                                          containsAddToCartButton: false,
                                          isFavorite: false,
                                          textFieldEnabled: false,
                                          containsAddFavorite: false,
                                          deleteType: 'CART',
                                          gross: product.gross > 0.0
                                              ? product.gross.toString()
                                              : '',
                                          birds: product.birds > 0
                                              ? product.birds
                                              : 0,
                                          pieces: product.pieces > 0.0
                                              ? product.pieces.toString()
                                              : '',
                                        ),
                                      );
                                    }

                                    return ListItem(
                                      product: product,
                                      isCart: true,
                                      isFavorite: false,
                                      containsAddToCartButton: false,
                                      containsAddFavorite: false,
                                      deleteType: 'CART',
                                      textFieldEnabled: false,
                                      gross: product.gross > 0.0
                                          ? product.gross.toString()
                                          : '',
                                      birds:
                                          product.birds > 0 ? product.birds : 0,
                                      pieces: product.pieces > 0.0
                                          ? product.pieces.toString()
                                          : '',
                                    );
                                  },
                                );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 10.0,
                left: 16.0,
                right: 16.0,
                child: BottomBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
