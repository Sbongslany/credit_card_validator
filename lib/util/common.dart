import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Common {
  static getInputDecorator(String text) {
    return InputDecoration(
      labelText: text,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static showAlert(BuildContext context, {String? title, String? message, Function? onOkPressed}) {
    // set up the ok button
    Widget okButton = TextButton(
      child: Text(
        'Ok',
        style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        if (onOkPressed != null) {
          onOkPressed();
        }
      },
    );

    // set up the cancel button
    Widget cancelButton = TextButton(
      child: Text(
        'Cancel',
        style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    Widget alert;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      alert = CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: message != null ? Text(message) : null,
        actions: [
          cancelButton,
          okButton,
        ],
      );
    } else {
      alert = AlertDialog(
        title: title != null ? Text(title) : null,
        content: message != null ? Text(message) : null,
        actions: [
          cancelButton,
          okButton,
        ],
      );
    }
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showSnackbar(
    String message, {
    Color backgroundColor = Colors.black,
    String? labelMessage,
    Color textColor = Colors.white,
  }) {
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,

      margin: EdgeInsets.zero,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      ),
      // padding: const EdgeInsets.all(10.0),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 10),
      action: labelMessage == null
          ? null
          : SnackBarAction(
              label: labelMessage,
              textColor: textColor,
              onPressed: () {
                messengerKey.currentState!.removeCurrentSnackBar();
              },
            ),
    );
    messengerKey.currentState!
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }
}
