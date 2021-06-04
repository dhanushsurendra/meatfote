import 'package:flutter/material.dart';

class ErrorHandler extends StatelessWidget {
  final String message;
  final double heightPercent;

  const ErrorHandler({
    Key key,
    @required this.message,
    @required this.heightPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * heightPercent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/waiting.png',
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  message,
                  softWrap: true,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
