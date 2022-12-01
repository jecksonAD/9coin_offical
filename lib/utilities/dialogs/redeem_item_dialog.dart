import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';

import 'generic_dialog.dart';

Future<bool> showRedeemItemDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    imageUrl: Assets.redeem,
    title: "Redeem Item?",
    content: "Please Comfirm, The item Redeen was not refundable",
    optionsBuilder: () => {
      "Back": false,
      "Redeem": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
