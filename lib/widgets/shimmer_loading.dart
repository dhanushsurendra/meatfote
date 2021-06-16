import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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

class OrdersShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: Colors.grey[300],
              ),
              width: double.infinity,
              height: 150.0,
            ),
          );
        },
      ),
    );
  }
}
