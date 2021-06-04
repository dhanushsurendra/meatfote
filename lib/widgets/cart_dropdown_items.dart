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
      height: cartItems.length * 65.0,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          final Product cartItem = cartItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              title: Text(cartItem.name),
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
