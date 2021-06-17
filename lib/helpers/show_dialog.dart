import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ShowDialog {
  static void showDialog(
    BuildContext context,
    DialogType type,
    String title,
    String desc,
    Function onTap,
    bool containsButtonCancel,
    Function onDismissCallback, {
    bool dismissOnTouchOutside = true,
    bool dismissOnBackKeyPress = true,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: desc,
      showCloseIcon: true,
      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      btnCancelOnPress: containsButtonCancel ? () {} : null,
      btnOkOnPress: onTap,
      onDissmissCallback: onDismissCallback,
      btnOkColor: containsButtonCancel
          ? Color(0xFF00CA71)
          : Theme.of(context).primaryColor,
      btnCancelColor:
          containsButtonCancel ? Theme.of(context).primaryColor : null,
    )..show();
  }
}
