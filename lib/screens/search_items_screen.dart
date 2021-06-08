import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/cart.dart';
import 'package:meatforte/providers/product.dart';
import 'package:meatforte/providers/search.dart';
import 'package:meatforte/screens/search_input_screen.dart';
import 'package:meatforte/widgets/bottom_bar.dart';
import 'package:meatforte/widgets/custom_app_bar.dart';
import 'package:meatforte/widgets/empty_image.dart';
import 'package:meatforte/widgets/error_handler.dart';
import 'package:meatforte/widgets/list_item.dart';
import 'package:meatforte/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SearchItemsScreen extends StatefulWidget {
  const SearchItemsScreen({Key key}) : super(key: key);

  @override
  _SearchItemsScreenState createState() => _SearchItemsScreenState();
}

class _SearchItemsScreenState extends State<SearchItemsScreen> {
  StreamSubscription<ConnectivityResult> subscription;

  bool _isLoading = true;
  String userId;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {});
    });
    userId = Provider.of<Auth>(context, listen: false).userId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      Future.delayed(Duration.zero).then((_) async {
        await Provider.of<Cart>(context, listen: false).getCartItems(userId);
      });
    }
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> _getSearchResults(String userId) async {
    await Provider.of<Search>(context, listen: false).getSearchResults(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            flexibleSpace: CustomAppBar(
              title: 'Search Results',
              containsBackButton: true,
              containsTrailingButton: true,
              trailingButtonIcon: Icon(
                Icons.search,
                color: Colors.white,
                size: 25.0,
              ),
              trailingButtonOnTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => SearchInputScreen(),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: FutureBuilder(
            future: Provider.of<Search>(context, listen: false)
                .getSearchResults(userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    width: 40.0,
                                    height: 15.0,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    width: 40.0,
                                    height: 15.0,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    width: 40.0,
                                    height: 15.0,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    width: 40.0,
                                    height: 15.0,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: ShimmerLoading(),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return RefreshIndicator(
                  onRefresh: () => _getSearchResults(userId),
                  child: ErrorHandler(
                    message: 'Something went wrong. Please try again.',
                    heightPercent: 0.85,
                  ),
                );
              }

              return Column(
                children: [
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Category: ',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${Provider.of<Search>(context).searchInput}',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${Provider.of<Search>(context).searchProducts.length} items',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Icon(
                              Icons.border_all_outlined,
                              size: 16.0,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Provider.of<Search>(context, listen: false)
                                .searchProducts
                                .length ==
                            0
                        ? EmptyImage(
                            message: 'No results found!',
                            imageUrl: 'assets/images/empty.png',
                            heightPercent: 0.7,
                          )
                        : SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 60.0),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: Provider.of<Search>(context)
                                    .searchProducts
                                    .length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final Product product = Provider.of<Search>(
                                    context,
                                    listen: false,
                                  ).searchProducts[index];

                                  return ChangeNotifierProvider.value(
                                    value: product,
                                    child: ListItem(
                                      containsAddToCartButton: true,
                                      product: product,
                                      isCart: false,
                                      isFavorite: true,
                                      textFieldEnabled: true,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: const SizedBox(height: 1),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomSheet: BottomBar(height: 60.0),
      ),
    );
  }
}
