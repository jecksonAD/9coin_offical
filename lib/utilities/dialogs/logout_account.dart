import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';

import 'generic_dialog.dart';

Future<bool> showLogoutAccountDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.logout,
    title: "Logout Your Account?",
    content: "Dear User ,Are You Comfirm Want To Logout",
    optionsBuilder: () => {
      "Cancel": false,
      "Confirm": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.DeleteAccount,
    title: "Delete Your Account?",
    content:
        "Dear User,Your Account will be deleted and all your point cannot be refund.",
    optionsBuilder: () => {
      "Cancel": false,
      "Confirm": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
