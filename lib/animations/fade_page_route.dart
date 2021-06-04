import 'package:flutter/cupertino.dart';

class FadePageRoute extends PageRouteBuilder {
  Widget childWidget;

  FadePageRoute({this.childWidget})
      : super(
          transitionDuration: Duration(milliseconds: 200),
          transitionsBuilder: (
            context,
            firstAnimation,
            secondAnimation,
            widget,
          ) {
            return FadeTransition(
              opacity: firstAnimation,
              child: widget,
            );
          },
          pageBuilder: (
            context,
            animation,
            secondaryAnimation,
          ) =>
              childWidget,
        );
}
