import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String?> showDialogwithString(context, title, content) {
  String? returnedString;
  return showDialog(
      context: context,
      builder: (context) => Platform.isAndroid
          ? AlertDialog(
              title: Text("$title"),
              content: Text("$content"),
              actions: [
                TextButton(
                    onPressed: () {
                      returnedString = "No";
                      Navigator.of(context).pop(returnedString);
                    },
                    child: Text("No, Cancel")),
                TextButton(
                    onPressed: () {
                      returnedString = "Yes";
                      Navigator.of(context).pop(returnedString);
                    },
                    child: Text("Yes, Continue"))
              ],
            )
          : CupertinoAlertDialog(
              title: Text("$title"),
              content: Text("$content"),
              actions: [
                TextButton(
                    onPressed: () {
                      returnedString = "No";
                      Navigator.of(context).pop(returnedString);
                    },
                    child: Text("No, Cancel")),
                TextButton(
                    onPressed: () {
                      returnedString = "Yes";
                      Navigator.of(context).pop(returnedString);
                    },
                    child: Text("Yes, Continue"))
              ],
            ));
}
