import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';

import 'generic_dialog.dart';

Future<bool> showUpdatedSuccessfulDialog(BuildContext context, String text) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.updated,
    title: "Update Successful!",
    content: text,
    optionsBuilder: () => {
      "Back": false,
    },
  ).then(
    (value) => value ?? false,
  );
}
