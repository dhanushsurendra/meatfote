import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/product.dart';
import 'package:meatforte/providers/products.dart';
import 'package:meatforte/widgets/error_handler.dart';
import 'package:meatforte/widgets/list_item.dart';
import 'package:meatforte/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';

class ProductsList extends StatefulWidget {
  final String type;
  final bool isFavorite;

  const ProductsList({
    Key key,
    this.type,
    @required this.isFavorite,
  }) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
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

  Future<void> _getProducts(String userId) async {
    await Provider.of<Products>(context, listen: false).getProducts(context, userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: FutureBuilder(
        future: Provider.of<Products>(context).getProducts(context, userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerLoading();
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              color: Theme.of(context).primaryColor,
              onRefresh: () => _getProducts(userId),
              child: ErrorHandler(
                message: 'Something went wrong!',
                heightPercent: 0.8,
              ),
            );
          }

          return Container(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: Provider.of<Products>(context).products.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final Product product =
                    Provider.of<Products>(context, listen: false)
                        .products[index];

                if (product.productType == widget.type) {
                  return ChangeNotifierProvider.value(
                    value: product,
                    child: ListItem(
                      containsAddToCartButton: true,
                      product: product,
                      isCart: false,
                      isInStock: product.isInStock,
                      isFavorite: widget.isFavorite,
                      containsAddFavorite: true,
                      textFieldEnabled: product.isInStock,
                      gross:
                          product.gross > 0.0 ? product.gross.toString() : '',
                      birds: product.birds > 0 ? product.birds : 0,
                      pieces:
                          product.pieces > 0.0 ? product.pieces.toString() : '',
                    ),
                  );
                }
                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}
