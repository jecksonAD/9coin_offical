import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';
import 'package:ninecoin/features/lucky_draw/ui/luckydraw_page.dart';

import 'generic_dialog.dart';

Future<bool> showDrawnSuccessfulDialog(BuildContext context, String value) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.updated,
    title: value == "No Enough Balance"
        ? "Drawn Unsuccessful!"
        : "Drawn Successful!",
    content: value,
    optionsBuilder: () => {
      "Back": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
