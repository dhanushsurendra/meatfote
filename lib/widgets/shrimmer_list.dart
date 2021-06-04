import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShrimmerList extends StatelessWidget {
  const ShrimmerList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.21,
              child: Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    topLeft: Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }
}
