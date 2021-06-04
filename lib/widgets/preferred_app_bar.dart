import 'package:flutter/material.dart';

class PreferredAppBar extends StatelessWidget {
  final Widget customAppBar;

  const PreferredAppBar({
    Key key,
    @required this.customAppBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70.0),
      child: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        flexibleSpace: customAppBar,
      ),
    );
  }
}
