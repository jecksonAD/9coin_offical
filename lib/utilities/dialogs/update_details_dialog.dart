import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';

import 'generic_dialog.dart';

Future<bool> showUpdateDetailsDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.updatedDetails,
    title: "Update your Details?",
    content: "Your Profile Will Be Update.",
    optionsBuilder: () => {
      "Cancel": false,
      "Confirm": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
