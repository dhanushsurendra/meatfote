import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final Function onTap;

  const Button({
    Key key,
    @required this.onTap,
    @required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
