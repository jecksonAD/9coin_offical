import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';

import 'generic_dialog.dart';

Future<bool> showDrawPointDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.redeem,
    title: "Draw Point?",
    content: "The Point was Unrefundable !",
    optionsBuilder: () => {
      "Back": false,
      "Confirm": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
