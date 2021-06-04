import 'package:flutter/material.dart';

class FontHeading extends StatelessWidget {
  final String text;

  const FontHeading({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
    );
  }
}
