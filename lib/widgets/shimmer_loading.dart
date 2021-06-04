import 'package:flutter/material.dart';
import 'package:meatforte/providers/product.dart';
import 'package:meatforte/providers/products.dart';
import 'package:provider/provider.dart';

import 'list_item.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListItem(
              containsAddToCartButton: true,
              product: null,
              isCart: false,
              isLoading: true,
              isFavorite: true,
              textFieldEnabled: true,
            );
          },
        ),
      ),
    );
  }
}
