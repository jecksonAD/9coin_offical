import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';

import 'generic_dialog.dart';

Future<bool> showEmailVerification(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.changePassword,
    title: "Email Verification",
    content: "Get the Verification Code From your email",
    optionsBuilder: () => {
      "Cancel": false,
      "Confirm": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
