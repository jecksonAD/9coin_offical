import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';

import 'generic_dialog.dart';

Future<bool> showNewVerificationDialog(BuildContext context, String text) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.updated,
    title: "Notice",
    content: text,
    optionsBuilder: () => {
      "Done": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
