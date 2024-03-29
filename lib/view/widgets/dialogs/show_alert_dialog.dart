import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String defaultActionText,
  String? cancelAcitionText,
  Function? onPressed,
  bool isCancelDefault = false,
  bool isDefaultDefault = true,
}) {
  if (!Platform.isIOS) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelAcitionText != null)
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelAcitionText),
            ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(defaultActionText),
          )
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (cancelAcitionText != null)
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            isDefaultAction: isCancelDefault,
            isDestructiveAction: !isCancelDefault,
            child: Text(cancelAcitionText),
          ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(true),
          isDefaultAction: isDefaultDefault,
          isDestructiveAction: !isDefaultDefault,
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}
