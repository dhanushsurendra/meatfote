import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:meatforte/helpers/show_dialog.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:meatforte/providers/cart.dart';
import 'package:meatforte/providers/product.dart';
import 'package:meatforte/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ListItem extends StatefulWidget {
  final Product product;
  final bool isCart;
  final bool containsAddToCartButton;
  final bool textFieldEnabled;
  final bool isLoading;
  final bool isFavorite;
  final bool isInStock;
  final bool containsAddFavorite;
  final String gross;
  final String pieces;
  final int birds;
  final String deleteType;

  const ListItem({
    Key key,
    @required this.product,
    @required this.isCart,
    @required this.isFavorite,
    @required this.textFieldEnabled,
    @required this.isInStock,
    this.isLoading = false,
    this.containsAddToCartButton = true,
    this.containsAddFavorite = false,
    this.gross,
    this.pieces,
    this.birds,
    this.deleteType,
  }) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  int _birdCount = 0;
  TextEditingController _grossController = TextEditingController(text: '');
  TextEditingController _piecesController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    if (!widget.isLoading) {
      _grossController = TextEditingController(text: widget.gross);
      _piecesController = TextEditingController(text: widget.pieces);
      _birdCount = widget.birds;
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).userId;

    Future<void> _addProductToCart() async {
      final _gross = _grossController.text;
      final _pieces = _piecesController.text;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (!widget.isInStock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product not in stock'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
        return;
      }

      if (_gross.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enter value to add product to cart.'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      } else if (_gross.isEmpty && _pieces.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enter value to add product to cart.'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
        return;
      } else if (_gross.isEmpty && _pieces.isNotEmpty) {
        return;
      } else {
        try {
          if (_gross.isNotEmpty && _pieces.isEmpty && _birdCount == 0) {
            await Provider.of<Cart>(context, listen: false).addToCart(
              userId,
              widget.product.id,
              gross: double.parse(_gross),
            );
          } else if (_gross.isNotEmpty &&
              _pieces.isNotEmpty &&
              _birdCount == 0) {
            await Provider.of<Cart>(context, listen: false).addToCart(
              userId,
              widget.product.id,
              gross: double.parse(_gross),
              pieces: double.parse(_pieces),
            );
          } else if (_gross.isNotEmpty && _pieces.isEmpty && _birdCount != 0) {
            await Provider.of<Cart>(context, listen: false).addToCart(
              userId,
              widget.product.id,
              gross: double.parse(_gross),
              birds: _birdCount,
            );
          }

          _grossController.text = '';
          _piecesController.text = '';
          setState(() {
            _birdCount = 0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added to cart!'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong!'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    }

    return widget.isLoading
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.21,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 4.0),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              width: 30.0,
                              height: 10.0,
                              color: Colors.grey[300],
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              width: 70.0,
                              height: 10.0,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Container(
                          width: 70.0,
                          height: 30.0,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            padding: const EdgeInsets.only(bottom: 8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0.0, 2.0),
                  color: Colors.black12,
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.21,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            topLeft: Radius.circular(5.0),
                          ),
                          child: Image.asset(
                            'assets/images/test.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      widget.containsAddFavorite
                          ? FavoriteIcon()
                          : widget.isCart
                              ? DeleteIcon(
                                  productId: widget.product.id,
                                  userId: userId,
                                  deleteType: widget.deleteType,
                                )
                              : !widget.isFavorite
                                  ? DeleteIcon(
                                      productId: widget.product.id,
                                      userId: userId,
                                      deleteType: widget.deleteType,
                                    )
                                  : Container(),
                      widget.containsAddToCartButton ||
                              widget.product.isFavorite
                          ? Positioned(
                              right: 8,
                              bottom: 9,
                              child: Consumer<Products>(
                                builder: (BuildContext context,
                                    Products products, Widget child) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (!widget.product.isInStock) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Product is not in stock'),
                                            behavior: SnackBarBehavior.floating,
                                            duration:
                                                const Duration(seconds: 1),
                                          ),
                                        );
                                        return;
                                      }
                                      await _addProductToCart();
                                    },
                                    child: Container(
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0.0, 2.0),
                                            blurRadius: 6.0,
                                            color: Colors.black12,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.add_shopping_cart_outlined,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.rupeeSign,
                                size: 15.0,
                              ),
                              Text(
                                widget.product.price.toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (widget.product.layout == "2")
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: TextField(
                                enabled: widget.textFieldEnabled,
                                controller: _piecesController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Pieces',
                                  labelStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                    vertical: 5.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text('gms'),
                          ],
                        ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: TextField(
                              enabled: widget.textFieldEnabled,
                              controller: _grossController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Gross',
                                labelStyle: TextStyle(
                                  fontSize: 12.0,
                                  color: Theme.of(context).accentColor,
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 5.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('kgs'),
                        ],
                      ),
                      if (widget.product.layout == "3")
                        Column(
                          children: [
                            Text(
                              'Birds',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (!widget.textFieldEnabled) {
                                      return;
                                    }
                                    if (_birdCount == 0) {
                                      return;
                                    }
                                    setState(() {
                                      _birdCount -= 1;
                                    });
                                  },
                                  child: Container(
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 14.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(_birdCount.toString()),
                                SizedBox(
                                  width: 10.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (!widget.textFieldEnabled) {
                                      return;
                                    }
                                    setState(() {
                                      _birdCount += 1;
                                    });
                                  },
                                  child: Container(
                                    width: 25.0,
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 14.0,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                !widget.product.isInStock ? Divider() : Container(),
                !widget.product.isInStock
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Out of stock',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          );
  }
}

class FavoriteIcon extends StatelessWidget {
  final String userId;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  const FavoriteIcon({Key key, this.userId}) : super(key: key);

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (BuildContext context, Product product, Widget widget) {
        return Positioned(
          right: 8,
          top: 8,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 5.0,
                child: Container(
                  child: LikeButton(
                    key: ValueKey(product.id),
                    onTap: (value) async {
                      try {
                        if (await check()) {
                          String userId =
                              Provider.of<Auth>(context, listen: false).userId;
                          await product.toggleFavorite(userId, product.id);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: product.isFavorite
                                  ? Text('Liked ${product.name}')
                                  : Text('Unliked ${product.name}'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        } else {
                          _showSnackBar(context, 'No internet!');
                          return false;
                        }
                        return true;
                      } on HttpException catch (_) {
                        print('HttpException');
                        _showSnackBar(context, 'Failed to update!');
                        return false;
                      } on SocketException catch (_) {
                        print('SocketException');
                        _showSnackBar(context, 'Failed to update!');
                        return false;
                      } catch (error) {
                        print(error);
                        _showSnackBar(context, 'Failed to update!');
                        return false;
                      }
                    },
                    size: 25.0,
                    circleColor: CircleColor(
                      start: Color(0xFFEF3E69),
                      end: Theme.of(context).primaryColor,
                    ),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Theme.of(context).primaryColor,
                      dotSecondaryColor: Theme.of(context).primaryColor,
                    ),
                    likeBuilder: (_) {
                      return Icon(
                        Icons.favorite,
                        color: product.isFavorite
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        size: 25.0,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DeleteIcon extends StatelessWidget {
  final String userId;
  final String productId;
  final String deleteType;

  DeleteIcon({
    @required this.productId,
    @required this.userId,
    @required this.deleteType,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8,
      top: 8,
      child: GestureDetector(
        onTap: () => {
          ShowDialog.showDialog(
            context,
            DialogType.WARNING,
            'Confirm delete',
            'Are you sure you want to delete?',
            () async {
              if (deleteType == 'CART') {
                await Provider.of<Cart>(context, listen: false)
                    .deleteCartItem(userId, productId);
              } else if (deleteType == 'FAVORITES') {
                await Provider.of<Products>(context, listen: false)
                    .deleteFavorite(userId, productId);
              }
            },
            true,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted successfully!'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        },
        child: Container(
          width: 35.0,
          height: 35.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0,
                color: Colors.black12,
              ),
            ],
          ),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
