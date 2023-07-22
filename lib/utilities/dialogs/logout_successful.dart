import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';

import 'generic_dialog.dart';

Future<bool> showSuccessfulLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.updated,
    title: "Logout Successful!",
    content: "Thank You See You Soon",
    optionsBuilder: () => {
      "Back": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> showSuccessfulDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.updated,
    title: "Account Deleted",
    content: "Your Account have been Deleted and it cannot be reverse.",
    optionsBuilder: () => {
      "Back": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
