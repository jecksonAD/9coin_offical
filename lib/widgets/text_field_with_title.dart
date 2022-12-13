import 'package:flutter/material.dart';
import 'package:ninecoin/typography/text_styles.dart';

class TextFieldWithTitle extends StatelessWidget {
  final String title;
  final String hintText;
  final String value;
  final TextEditingController inputbar;
  const TextFieldWithTitle({
    Key? key,
    required this.title,
    required this.value,
    required this.hintText,
    required this.inputbar,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    inputbar.text = value;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
            child: Text(title, style: CoinTextStyle.orangeTitle3),
          ),
          TextField(
            decoration: InputDecoration(hintText: hintText),
            controller: inputbar,
          ),
        ],
      ),
    );
  }
}
