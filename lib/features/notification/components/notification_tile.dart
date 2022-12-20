import 'package:flutter/material.dart';
import 'package:ninecoin/typography/text_styles.dart';

import '../../../main.dart';
import '../../../model/news/news_model.dart';
import '../../category/api/merchant.dart';
import '../../category/ui/product_details_page.dart';
import '../../news/services/news.dart';
import '../../news/ui/news_details_notification_page.dart';
import '../ui/notification_detail_page.dart';

class NotificationTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final String date;
  final String notifiable_type;
  final String notifiable_id;

  const NotificationTile(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.notifiable_type,
      required this.notifiable_id,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print(notifiable_type);
        if (notifiable_type == "News") {
          GetNews news;
          Newsdetail(notifiable_id).then((value) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewsDetailsNotificationPage(
                      news: value,
                      index: 0,
                    )));
          });
        } else if (notifiable_type == "Merchant") {
          print(notifiable_type);
          GetNews news;
          Merchant getdata = Merchant();
          // getdata.Featuremerchant();
          getdata.Featuremerchant().then((value) {
            print(value[0]['id']);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                    value[0]['id'],
                    value[0]['name'],
                    value[0]['image'],
                    value[0]['totalproductimage'],
                    value[0]['randomnumber'])));
          });
        } else if (notifiable_type == "LuckyDraw") {
          print(notifiable_type);
          GetNews news;
          Merchant getdata = Merchant();
          // getdata.Featuremerchant();
          getdata.Featuremerchant().then((value) {
            print(value[0]['id']);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                    value[0]['id'],
                    value[0]['name'],
                    value[0]['image'],
                    value[0]['totalproductimage'],
                    value[0]['randomnumber'])));
          });
        } else if (notifiable_type == "Notification") {
          //  print(notifiable_type);
          GetNews news;
          Merchant getdata = Merchant();
          // getdata.Featuremerchant();
          getdata.Featuremerchant().then((value) {
            print(value[0]['id']);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NotificationDetailsNotificationPage(
                      title: title,
                      subtitle: subtitle,
                      date: date,
                    )));
          });
        }
      },
      child: Column(
        children: [
          ListTile(
            leading: icon,
            title: Text(title, style: CoinTextStyle.title3Bold),
            subtitle: Text(subtitle, style: CoinTextStyle.title4),
            trailing: Text(date),
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}
