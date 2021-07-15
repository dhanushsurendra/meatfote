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
                  fontSize: 14.0,
                ),
              ),
              subtitle: Row(
                children: [
                  cartItem.pieces > 0
                      ? Text('Pieces: ${cartItem.pieces} ')
                      : SizedBox.shrink(),
                  Text('Gross: ${cartItem.gross.toString()} '),
                  cartItem.birds > 0
                      ? Text('Birds: ${cartItem.birds}')
                      : SizedBox.shrink(),
                ],
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
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
