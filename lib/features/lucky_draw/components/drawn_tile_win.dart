import 'package:flutter/material.dart';
import 'package:ninecoin/features/lucky_draw/ui/drawn_details_page.dart';

class DrawnTileWin extends StatelessWidget {
  final String title;
  final String luckydrawid;
  final String id;
  final String startingDate;
  final String endDate;
  final Function() onTap;
  const DrawnTileWin({
    Key? key,
    required this.title,
    required this.luckydrawid,
    required this.id,
    required this.startingDate,
    required this.endDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    Text("$startingDate - $endDate"),
                  ],
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
