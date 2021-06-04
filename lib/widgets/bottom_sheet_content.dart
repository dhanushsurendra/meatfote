import 'package:flutter/material.dart';
import 'package:meatforte/widgets/button.dart';

class BottomSheetContent extends StatelessWidget {
  final String type;
  final Function onTap;
  final bool isAuth;

  const BottomSheetContent({
    Key key,
    this.type = '',
    @required this.onTap,
    @required this.isAuth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.0,
      child: isAuth
          ? GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    type == 'SIGNUP'
                        ? 'Already a member?'
                        : type == 'LOGIN'
                            ? 'Don\'t have an account?'
                            : '',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    type == 'SIGNUP'
                        ? 'Login'
                        : type == 'LOGIN'
                            ? 'Signup'
                            : '',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 32.0,
              ),
              child: Button(onTap: () {}, buttonText: 'CHECKOUT'),
            ),
    );
  }
}
