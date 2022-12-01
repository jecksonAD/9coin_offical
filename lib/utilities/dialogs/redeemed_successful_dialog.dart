import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';

import 'generic_dialog.dart';

Future<bool> showRedeemedSuccessfulDialog(BuildContext context, String value) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.updated,
    title: "Redeemed Successful!",
    content: value,
    optionsBuilder: () => {
      "Ok": false,
    },
  ).then(
    (value) => value ?? false,
  );
}
