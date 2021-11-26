import 'package:flutter/material.dart';
import 'package:meatforte/providers/product.dart';

class CartDropDownItems extends StatelessWidget {
  final List<Product> cartItems;

  const CartDropDownItems({
    Key key,
    this.cartItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: cartItems.length * 80.0,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          final Product cartItem = cartItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              title: Text(
                cartItem.name,
                maxLines: 2,
                style: TextStyle(
                  fontSize:
                      MediaQuery.of(context).size.width <= 320.0 ? 12.0 : 14.0,
                ),
              ),
              subtitle: Row(
                children: [
                  cartItem.pieces > 0
                      ? Text(
                          'Pieces: ${cartItem.pieces} ',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width <= 320.0
                                ? 10.0
                                : Theme.of(context).textTheme.subtitle2.fontSize,
                          ),
                        )
                      : SizedBox.shrink(),
                  Text(
                    'Gross: ${cartItem.gross.toString()} ',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width <= 320.0
                          ? 10.0
                          : Theme.of(context).textTheme.subtitle2.fontSize,
                    ),
                  ),
                  cartItem.birds > 0
                      ? Text(
                          'Birds: ${cartItem.birds} ',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width <= 320.0
                                ? 10.0
                                : Theme.of(context).textTheme.subtitle2.fontSize,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  cartItem.imageUrl,
                ),
              ),
              trailing: Text(
                cartItem.price.toStringAsFixed(2),
              ),
            ),
          );
        },
      ),
    );
  }
}
