import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ninecoin/assets/assets.dart';
import 'package:ninecoin/colors/colors.dart';
import 'package:ninecoin/features/home/components/my_bottom_navigation_bar.dart';
import 'package:ninecoin/typography/text_styles.dart';

import '../../../model/news/news_model.dart';

class NotificationDetailsNotificationPage extends StatelessWidget {
  static route(
      {required String title, required String subtitle, required String date}) {
    return MaterialPageRoute(
      builder: (context) => NotificationDetailsNotificationPage(
        title: title,
        subtitle: subtitle,
        date: date,
      ),
    );
  }

  final String title;
  final String subtitle;
  final String date;
  const NotificationDetailsNotificationPage(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CoinColors.fullBlack,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("News"),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              Text(title, style: CoinTextStyle.orangeTitle2),
              const SizedBox(height: 12),
              Text(subtitle, style: CoinTextStyle.title3),
              const SizedBox(height: 12),
              Text(date,
                  style:
                      CoinTextStyle.title4.copyWith(color: CoinColors.black54)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
